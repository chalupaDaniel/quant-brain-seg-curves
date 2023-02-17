function [comparisonTable] = writeComparisonsToTable(comparisonTable, groupAList, groupALabel, groupBList, groupBLabel, hemiLabel, dataLabel, cors, chis, intersects, bhats)

        for a = 1:size(cors,1)
            for b = 1:size(cors,2)
                if isnan(cors(a,b))
                    continue
                end
                subAName = groupAList(a);
                subBName = groupBList(b);
                comparisonTable = [comparisonTable ;{subAName, groupALabel, subBName, groupBLabel, hemiLabel, dataLabel, cors(a,b), chis(a,b), intersects(a,b), bhats(a,b)}];
            end
        end
end

