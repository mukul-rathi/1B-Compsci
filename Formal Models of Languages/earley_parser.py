"""
This is an implementation of the Earley Parser by Mukul Rathi.
"""

import sys

### define context-free grammar

nonTerminals = ["S", "NP", "VP", "PP", "N", "V", "PP"]
alphabet = ["can", "fish", "in", "rivers", "they", "in", "December"]
productions = {
    "S": [["NP", "VP"]],
    "NP": [["N", "PP"], ["N"]],
    "PP": [["P", "NP"]],
    "VP": [["VP", "PP"], ["V", "VP"], ["V", "NP"], ["V"]],
    "N": ["can", "fish", "rivers", "December", "they"],
    "P": ["in"],
    "V": ["can", "fish"],
}


class Edge:
    """
    This class represents the edge in a chart.
    

    Attributes:
        lhs -> prodSeen . prodLeft   (these three attributes form a rule)
        start: last word parsed before this production (NB 1-indexing words, so 0 = no words parsed)
        end: last word parsed including this production i.e. we have parsed a_(start+1)...a_(end)
        hist: list of other edges used to construct parse
    """

    def __init__(self, lhs, prodSeen, prodLeft, start, end, hist=[]):
        self.lhs = lhs
        self.prodSeen = prodSeen
        self.prodLeft = prodLeft
        self.start = start
        self.end = end
        self.hist = hist

    def __eq__(self, other):
        """
        Override equality so can check if edge already present when 
        expanding nodes in predict step
        """
        eq = self.lhs == other.lhs
        eq = eq and self.prodSeen == other.prodSeen
        eq = eq and self.prodLeft == other.prodLeft
        eq = eq and self.start == other.start
        eq = eq and self.end == other.end
        return eq

    def __repr__(self):
        """
        Pretty Printing an Edge
        """
        stringRep = (
            f'( {self.lhs} ->{" ".join(self.prodSeen)} . {" ".join(self.prodLeft)}'
        )
        stringRep += f" [{self.start},{self.end}] hist={self.hist} )"
        return stringRep


def predict(word, chart, j):
    """
    This adds edges to the chart by expanding the first non-terminal to the right of the dot.

    I.e. if we have A -> alpha . B beta [i,j] and B-> gamma
        we add an edge B-> gamma [j, j]  
        start = j since that's last word parsed before new B production)
        end = j since we have yet to parse any words with new B production. 
    Args:
        word: next word in sentence (for forward look-up)
        chart: chart of edges
    
    """
    for edge in chart:

        if (
            not edge.prodLeft or edge.prodLeft[0] in alphabet
        ):  # if no non-terminal to expand, skip this edge
            continue
        # perform forward lookup for privileged set of non-terminals
        elif edge.prodLeft[0] in ["N", "V", "P"]:
            if word in productions[edge.prodLeft[0]] and edge.end == j - 1:
                newEdge = Edge(
                    lhs=edge.prodLeft[0],
                    prodSeen=[],
                    prodLeft=[word],
                    start=edge.end,
                    end=edge.end,
                )
                if newEdge not in chart:
                    chart.append(newEdge)

        # for other non-literals expand all productions
        else:
            for production in productions[edge.prodLeft[0]]:
                newEdge = Edge(
                    lhs=edge.prodLeft[0],
                    prodSeen=[],
                    prodLeft=production,
                    start=edge.end,
                    end=edge.end,
                )
                if newEdge not in chart:
                    chart.append(newEdge)


def scan(word, chart, j):
    """
    If we have edge consistent with input word, we move dot along and create new edge.

    I.e. if we have A -> .a [i, j-1] and a = a_j where the sentence = a_1....a_n
        add edge A -> a.[i, j]

    Args:
        word: current word being scanned
        chart: chart of edges
        j: position of word in sentence

    """
    for edge in chart:
        if edge.end == j - 1:  # i.e. we've scanned words 1...j-1 before
            if (
                edge.prodLeft and word == edge.prodLeft[0]
            ):  # consistent with word we've seen
                # create new edge by shifting dot along
                newEdge = Edge(
                    lhs=edge.lhs,
                    prodSeen=(edge.prodSeen + [edge.prodLeft[0]]),
                    prodLeft=edge.prodLeft[1:],
                    start=edge.start,
                    end=(edge.end + 1),
                )
                if newEdge not in chart:
                    chart.append(newEdge)


def complete(chart):
    """
    Propagate fully explored edges in chart

    I.e. if we have A -> alpha . B . beta [i,k] and B -> gamma . [k,j]
        then we add the edge A -> alpha B. beta [i,j] and add edge B to its history

    Args:
        chart: the Earley parser chart

    """
    for idx, edge in enumerate(chart):
        if not edge.prodLeft:  # we've finished expanding the node
            for edge2 in chart:
                if idx in edge2.hist:  # we've propagated this before.
                    continue
                if (
                    edge2.end == edge.start
                    and edge2.prodLeft
                    and edge2.prodLeft[0] == edge.lhs
                ):  # we've found our edge A
                    newEdge = Edge(
                        lhs=edge2.lhs,
                        prodSeen=(edge2.prodSeen + [edge2.prodLeft[0]]),
                        prodLeft=edge2.prodLeft[1:],
                        start=edge2.start,
                        end=(edge.end),
                        hist=edge2.hist + [idx],
                    )  # create our new edge
                    if newEdge not in chart:
                        chart.append(newEdge)
                    else:  # update history of existing edge
                        existingEdge = chart[chart.index(newEdge)]
                        if idx not in existingEdge.hist:
                            existingEdge.hist.append(idx)


def earleyParse(sentence=[]):
    """
    This parses the sentence by performing the three steps
        1) Predict
        2) Scan
        3) Complete
    for each of the words in the sentence.

    Returns;
        chart: the completed Earley parser chart
    """
    start = Edge(lhs="S", prodSeen=[], prodLeft=productions["S"][0], start=0, end=0)
    chart = [start]  # initialise chart
    for index, word in enumerate(sentence):
        predict(word, chart, index + 1)
        scan(word, chart, index + 1)  # 1-index words
        complete(chart)
    return chart


if __name__ == "__main__":
    chart = earleyParse(sys.argv[1:])
    for i, edge in enumerate(chart):
        print(f"{i}: {edge}")
