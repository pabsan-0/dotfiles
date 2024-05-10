#! /usr/bin/env -S bash

parse_markdown_title() {
    grep "^#" "$1" | head -n 1 | sed 's/#//g'
}

parse_markdown_links() {
    sed -n 's:\[.*\](\(.*\)):\1:gp' "$1"
}

echo "digraph G {"
echo "    graph [layout=dot rankdir=LR]"

# Loop through extracted links with read & parse titles
for file in $(find . -type f -name "*.md" -print); do
    name=$(parse_markdown_title "$file")
    name=${name// /_}

    echo ""
    echo "    // parsing $name: $file"
    echo "    $name [href=\"$file\"]"

    # Loop through extracted links with read & parse titles
    while read -r link; do
        linked_title=$(parse_markdown_title "$link")
        linked_title=${linked_title// /_}
        echo "   {$name} -> $linked_title"
    done < <(parse_markdown_links "$file")
done


echo "}"
