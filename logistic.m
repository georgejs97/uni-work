function lr_par = logistic()
% Find the coefficients of a logistic regression model of the probability
% of a product being returned given the rating given by the customer. Use
% data from all customers that returned a product, which will be a vector
% of ratings and a vector of whether each transaction was a sale or refund.
% Return the required parameters as output
    T = readtable("purchasing_order.csv");
    C = table2cell(T);
    rows = size(C,1);
    
    % Create a vector of all relevant customerIDs, to then generate vectors
    complainers = zeros(1,200);
    c = 1;
    for i = 1:rows
        if C{i,6} == 'Y'
            if not(ismember(C{i,2},complainers))
                complainers(c) = C{i,2};
                c = c+1;
            end
        end
    end
    
    % Generating the vectors of r: rating for each transaction, 
    % p:binary outcome of return=1 and sale=0
    r = [];
    p = [];
    for i = 1:rows
        if ismember(C{i,2},complainers)
            r = [r C{i,5}];
            if C{i,6} == 'Y'
                p = [p 1];
            else
                p = [p 0];
            end
        end
    end
    
    % Find the parameters, with secondary function 'logreg'
    lr_par = fminsearch(@(a)logreg(a,r,p),[0 0]);
    
    % Plot a graph of the sigmoid function and datapoints
    hx = linspace(0,6,101);
    plot(r,p,'*',hx,1./(1+exp(-lr_par(1)*hx-lr_par(2))));
    lg = legend('Raw Data','Logistic Regression');
    set(lg,'Location','East','box','off');
    xlabel('Rating');
    axis([0 6 -0.1 1.1]);
end
    
function S = logreg(a,h,p) 
% Function fwhich defines the logistic regression finction, a = [a , b]
    S = 0;
    for k = 1:length(h)
        S = S + (p(k)-1/(1+exp(-a(1)*h(k)-a(2))))^2;
    end
end