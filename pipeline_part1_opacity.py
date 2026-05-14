import os
import glob
import re

dart_files = glob.glob('lib/**/*.dart', recursive=True)

count = 0
for filepath in dart_files:
    with open(filepath, 'r', encoding='utf-8') as f:
        content = f.read()

    orig_content = content
    new_content = re.sub(r'\.withOpacity\(([^)]+)\)', r'.withValues(alpha: \1)', content)
    
    if new_content != orig_content:
        with open(filepath, 'w', encoding='utf-8') as f:
            f.write(new_content)
        count += 1

print(f"Fixed .withOpacity to .withValues in {count} files natively.")
