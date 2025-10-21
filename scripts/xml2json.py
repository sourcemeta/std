import sys
import xml.etree.ElementTree as ET
import json
import pathlib


def xml_to_dict(element):
    result = {}

    if element.attrib:
        result['@attributes'] = element.attrib

    children = list(element)
    if children:
        child_dict = {}
        for child in children:
            child_data = xml_to_dict(child)
            if child.tag in child_dict:
                if not isinstance(child_dict[child.tag], list):
                    child_dict[child.tag] = [child_dict[child.tag]]
                child_dict[child.tag].append(child_data)
            else:
                child_dict[child.tag] = child_data
        result.update(child_dict)

    if element.text and element.text.strip():
        if result:
            result['@text'] = element.text.strip()
        else:
            return element.text.strip()

    return result if result else None


def main():
    if len(sys.argv) != 3:
        print("Usage: xml2json.py <input-xml> <output-json>", file=sys.stderr)
        sys.exit(1)

    input_file = sys.argv[1]
    output_file = sys.argv[2]

    try:
        with open(input_file, 'r') as file:
            xml_data = file.read()

        root = ET.fromstring(xml_data)

        result = {
            root.tag: xml_to_dict(root)
        }

        output_path = pathlib.Path(output_file)
        output_path.parent.mkdir(parents=True, exist_ok=True)

        with open(output_path, 'w') as file:
            json.dump(result, file, indent=2)
            file.write('\n')

    except Exception as error:
        print(f"Error: {error}", file=sys.stderr)
        sys.exit(1)


if __name__ == "__main__":
    main()
