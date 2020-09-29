class Concept:

    @staticmethod
    def calc_(concepts):
        shop_concepts_with_weight = {'basic': 0.3, 'daily': 0.3, 'simple': 0.6, 'chic': 0.7, 'street': 0.6,
                                     'romantic': 0.7, 'unique': 0.8, 'sexy': 0.7, 'vintage': 0.7}
        result = {}
        result.update(concepts)
        for item in result.keys():
            result[item] *= shop_concepts_with_weight[item]
        result = sorted(result.items(), key=(lambda x: x[1]), reverse=True)
        res = []
        for item in result:
            res.append(item[0])
        return res[:3]


    @staticmethod
    def concept_format(concept):
        concepts = {
            'daily': '데일리',
            'vintage': '빈티지',
            'street': '스트릿',
            'romantic':'로맨틱',
            'simple': '심플',
            'chic': '시크',
            'unique': '유니크',
            'basic': '베이직',
            'sexy': '섹시'
        }
        return concepts.get(concept.lower())