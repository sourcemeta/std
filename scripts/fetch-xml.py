import sys
import urllib.request
import xml.etree.ElementTree as ET
import json


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
    if len(sys.argv) != 2:
        print("Usage: fetch-xml <URL>", file=sys.stderr)
        sys.exit(1)

    url = sys.argv[1]

    try:
        with urllib.request.urlopen(url) as response:
            xml_data = response.read()

        root = ET.fromstring(xml_data)

        result = {
            root.tag: xml_to_dict(root)
        }

        print(json.dumps(result, indent=2))

    except Exception as error:
        print(f"Error: {error}", file=sys.stderr)
        sys.exit(1)


if __name__ == "__main__":
    main()
