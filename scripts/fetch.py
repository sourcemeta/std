import sys
import urllib.request
import pathlib


def main():
    if len(sys.argv) != 3:
        print("Usage: fetch.py <URL> <output-file>", file=sys.stderr)
        sys.exit(1)

    url = sys.argv[1]
    output_file = sys.argv[2]

    try:
        with urllib.request.urlopen(url) as response:
            data = response.read()

        output_path = pathlib.Path(output_file)
        output_path.parent.mkdir(parents=True, exist_ok=True)

        with open(output_path, 'wb') as file:
            file.write(data)

    except Exception as error:
        print(f"Error: {error}", file=sys.stderr)
        sys.exit(1)


if __name__ == "__main__":
    main()
