function data = handwrittenPrnist(n,m)
    data = prdatafile('HandWrittenDigits', 'imreadGray');
    data = setlablist(data, ['digit_0'; 'digit_1'; 'digit_2'; 'digit_3'; 'digit_4'; 'digit_5'; 'digit_6'; 'digit_7'; 'digit_8'; 'digit_9']);
    labelList = [];
    
    for digit = 0:9
        for obj = 1:30
            labelList = [labelList; sprintf('digit_%d', digit) ];
        end
    end
    data = setlabels(data, labelList, 1:300); 
    
    %alldata = getdata(data);
    %obj = reshape(alldata(1, :), 38, 45);
    %disp(obj);
    
    disp(data.featsize);
    
    if nargout == 0
        help(mfilename);
    end
    
    if nargin < 1 | isempty(n)
      n = [0:9];
    end
    
    if nargin < 2
        m = [1:200];
    end
    
    if max(n) > 9 | max(m) > 1000 | min(n) < 0 | min(m) < 1
        error('Class numbers or object numbers out of range')
    end

    data = seldat(data);
end