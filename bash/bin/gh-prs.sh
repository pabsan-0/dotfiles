ORGANIZATION="fluendo"

gh search prs --owner "$ORGANIZATION" --state open --author pabsan-0
gh search prs --owner "$ORGANIZATION" --state open --reviewed-by pabsan-0 --review-requested pabsan-0
