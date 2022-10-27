# Compare two directory trees
diff <(cd directory1 && find | sort) <(cd directory2 && find | sort)