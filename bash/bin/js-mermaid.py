#! /usr/bin/env python3
import argparse
import glob
import json
import os
import sys

import esprima

"""
Generate a Mermaid UML class diagram from JavaScript source files.

This script parses one or more JavaScript files using Esprima and extracts
class-level structure to produce a Mermaid `classDiagram`. 
"""


def debug_node(node):
    """Helper to print a simplified version of an AST node for debugging."""
    if not node or not hasattr(node, "type"):
        return "{ non-node object }"
    node_dict = {k: v for k, v in node.__dict__.items() if k not in ["parent"]}
    try:
        return json.dumps(node_dict, default=lambda o: "<...>", indent=2)
    except TypeError:
        return str(node_dict)


def get_file_paths(patterns):
    """
    Expands glob patterns into a unique, sorted list of file paths.
    """
    all_files = []
    for pattern in patterns:
        all_files.extend(glob.glob(pattern, recursive=True))
    return sorted(list(set(all_files)))


def parse_js_files(file_paths):
    """
    Parses a list of JavaScript files and builds a data structure of class info.
    """
    class_defs = {}

    for path in file_paths:
        try:
            with open(path, "r", encoding="utf-8") as f:
                content = f.read()
            ast = esprima.parseModule(content, {"loc": True})

            for node in ast.body:
                if node.type == "ClassDeclaration":
                    class_name = node.id.name

                    if class_name not in class_defs:
                        class_defs[class_name] = {
                            "methods": set(),
                            "constructor_attributes": set(),
                            "other_attributes": set(),
                            "dependencies": set(),
                            "parent": None,
                        }

                    if node.superClass:
                        class_defs[class_name]["parent"] = node.superClass.name

                    try:
                        visit_class_body(node, class_name, class_defs)
                    except Exception as e:
                        print(
                            f"\n--- DEBUG: Error while processing class '{class_name}' in file '{path}' ---",
                            file=sys.stderr,
                        )
                        print(f"Error: {e}", file=sys.stderr)
                        print(
                            f"This error occurred while analyzing the structure of the class.",
                            file=sys.stderr,
                        )
                        print(
                            f"The AST for the problematic class node is:\n{debug_node(node)}\n",
                            file=sys.stderr,
                        )
                        pass

        except Exception as e:
            print(
                f"Warning: Could not parse file '{path}'. Reason: {e}", file=sys.stderr
            )

    return class_defs


def visit_class_body(class_node, class_name, class_defs):
    """
    Visits the body of a class to find methods and attributes.
    """
    for node in class_node.body.body:
        if node.type == "MethodDefinition":
            is_constructor = node.kind == "constructor"
            if is_constructor:
                params = [p.name for p in node.value.params]
                class_defs[class_name]["constructor_params"] = ", ".join(params)
            else:
                method_name = node.key.name
                class_defs[class_name]["methods"].add(method_name)

            if node.value.body:
                visit_expression(
                    node.value.body, class_name, class_defs, is_constructor
                )


def visit_expression(node, class_name, class_defs, is_in_constructor):
    """
    Recursively finds 'this.attribute' assignments and 'new' expressions.
    """
    if not node or not hasattr(node, "type"):
        return

    if (
        node.type == "AssignmentExpression"
        and hasattr(node.left, "object")
        and node.left.object
        and node.left.object.type == "ThisExpression"
    ):
        attr_name = (
            node.left.property.name
            if hasattr(node.left.property, "name")
            else "[dynamic]"
        )
        if is_in_constructor:
            class_defs[class_name]["constructor_attributes"].add(attr_name)
        else:
            class_defs[class_name]["other_attributes"].add(attr_name)

    if node.type == "NewExpression" and hasattr(node.callee, "name"):
        dependency_name = node.callee.name
        class_defs[class_name]["dependencies"].add(dependency_name)

    for key in node.__dict__:
        child = node.__dict__.get(key)
        if isinstance(child, esprima.nodes.Node):
            visit_expression(child, class_name, class_defs, is_in_constructor)
        elif isinstance(child, list):
            for child_node in child:
                if child_node:
                    visit_expression(
                        child_node, class_name, class_defs, is_in_constructor
                    )


def generate_mermaid_diagram(class_defs):
    """
    Generates the Mermaid.js class diagram syntax from the parsed data.
    """
    mermaid_lines = ["classDiagram"]
    for cls, info in class_defs.items():
        mermaid_lines.append(f"class {cls} {{")
        for attr in sorted(list(info["constructor_attributes"])):
            mermaid_lines.append(f"  -{attr}")

        other_only_attrs = info["other_attributes"] - info["constructor_attributes"]
        for attr in sorted(list(other_only_attrs)):
            mermaid_lines.append(f"  -{attr}*")

        if "constructor_params" in info:
            mermaid_lines.append(f"  +constructor({info['constructor_params']})")

        for method in sorted(list(info["methods"])):
            mermaid_lines.append(f"  +{method}()")
        mermaid_lines.append("}")

    for cls, info in class_defs.items():
        if info["parent"]:
            mermaid_lines.append(f"{info['parent']} <|-- {cls}")
        for dep in sorted(list(info["dependencies"])):
            if cls != dep and dep in class_defs:
                mermaid_lines.append(f"{cls} --> {dep} : creates")
    return "\n".join(mermaid_lines)


def main():
    parser = argparse.ArgumentParser(
        description="Generate a Mermaid UML class diagram from JavaScript files using Esprima."
    )
    parser.add_argument(
        "input_patterns",
        nargs="+",
        help="One or more JavaScript source files or glob patterns.",
    )
    parser.add_argument(
        "-o",
        "--output",
        type=str,
        help="Output file for the Mermaid diagram. If not specified, prints to stdout.",
    )

    args = parser.parse_args()

    file_paths = get_file_paths(args.input_patterns)
    if not file_paths:
        print("No files found matching the provided patterns.", file=sys.stderr)
        return
    print(f"Found {len(file_paths)} files to parse.", file=sys.stderr)

    class_data = parse_js_files(file_paths)
    diagram = generate_mermaid_diagram(class_data)

    if args.output:
        with open(args.output, "w", encoding="utf-8") as f:
            f.write(diagram)
        print(f"Mermaid diagram saved to {args.output}", file=sys.stderr)
    else:
        # The final diagram is the ONLY thing printed to standard output.
        print(diagram)


if __name__ == "__main__":
    main()
