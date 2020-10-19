from math import floor

class SizeParser:
    @staticmethod
    def decimal_parser(sizes, tag):
        size = []
        if sizes is None:
            size = None
        else:
            for item in sizes:
                if tag == 'hip' or tag == 'bust':
                    size.append(float(floor(float(item) * 2)))
                elif tag == 'waist':
                    size.append(float(floor(float(item) / 1.27)))
                else:
                    size.append(float(floor(float(item))))
        return size

    @staticmethod
    def size_matcher(size):
        size_tag = ['s', 'm', 'l', 'xl', 'xxl']
        parsed_size = {}
        free_flag = False
        for v, item in enumerate(size):
            if len(size[item]) == 1:
                free_flag = True
            for k, value in enumerate(size[item]):
                if free_flag is True:
                    size_tagged = 'free'
                else:
                    if k > 4: continue
                    size_tagged = size_tag[k]
                if size_tagged not in parsed_size.keys():
                    parsed_size[size_tagged] = {}
                parsed_size[size_tagged][item] = value
        return parsed_size

    @staticmethod
    def list_size_parse(size, array):
        if array is None:
            return
        for number in array:
            size.append(float(number))