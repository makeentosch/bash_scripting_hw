#!/bin/bash

while [[ $# -gt 0 ]]; do
    case "$1" in
        -d) dir_path="$2"; shift 2 ;;
        -n) name="$2"; shift 2 ;;
        *) echo "Неизвестная опция: $1"; exit 1 ;;
    esac
done

[[ -z "$dir_path" || -z "$name" ]] && { echo "Ошибка: -d и -n обязательны"; exit 1; }
[[ ! -d "$dir_path" ]] && { echo "Ошибка: $dir_path не каталог"; exit 1; }

# Создаем tar.gz и кодируем в base64
archive=$(tar -czf - -C "$dir_path" . | base64)

# Генерируем скрипт-распаковщик
cat > "$name" << 'EOF'
#!/bin/bash
unpack_dir="."
while [[ $# -gt 0 ]]; do
    case "$1" in
        -o) unpack_dir="$2"; shift 2 ;;
        *) echo "Неизвестная опция: $1"; exit 1 ;;
    esac
done
[[ ! -d "$unpack_dir" ]] && mkdir -p "$unpack_dir"
ARCHIVE | tar -xzf - -C "$unpack_dir"
EOF

# Заменяем ARCHIVE на закодированный архив
sed -i "s|ARCHIVE|echo '$archive' \| base64 -d|" "$name"
chmod +x "$name"
