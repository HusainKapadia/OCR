function data = handwrittenPrnist()
    data = prdatafile('HandWrittenDigits', 'imreadGray');
    data = setlablist(data, ['digit_0'; 'digit_1'; 'digit_2'; 'digit_3'; 'digit_4'; 'digit_5'; 'digit_6'; 'digit_7'; 'digit_8'; 'digit_9']);
    labelList = [];
    
    for digit = 0:9
        for obj = 1:30
            labelList = [labelList; sprintf('digit_%d', digit) ];
        end
    end
    
    data = setlabels(data, labelList, 1:300); 
end