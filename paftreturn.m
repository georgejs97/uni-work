function U = paftreturn()
% Creates a table with the required output which investigates whether a
% a return makes this customer less likely to buy future products. 
% All computation was done in 'paftreturn2'
    Category={'Customers who refunded';'All customers'};
    a = paftreturn2(true);
    b = paftreturn2(false);
    TotalSalesValue={a(1);b(1)};
    AfterRefundValue={a(2);b(2)};
    Percentage={a(3);b(3)};
    U = table(TotalSalesValue,AfterRefundValue,Percentage);
    U.Properties.RowNames = Category;
end

function v = paftreturn2(verbose)
% If verbose==TRUE,considering only customers who have returned a product, 
% find what percentage of purchases were made after a refund/return.
% If verbose==FALSE, now consider all customers
    T = readtable("purchasing_order.csv");
    C = table2cell(T);
    rows = size(C,1);
    
    % Find whether sale or refund and find IDs of those who got a refund
    sales = zeros(1,rows);
    refunds = zeros(1,rows);
    complainers = zeros(1,200);
    c=1;
    for i = 1:rows
        if C{i,6} == 'N'
            sales(i) = 1;
        else
            refunds(i) = 1;
            complainers(c) = C{i,2};
            c = c+1;
        end
    end
    
    % Gives the total value of all sales ('value') when verbose=FALSE
    % Gives total value of all sales made to customers who ever got a
    % refund when verbose=TRUE
    value = 0;
    for i = find(sales)
        if verbose==true
            if ismember(C{i,2},complainers)
                value = value + C{i,4};
            end
        else
            value = value + C{i,4};
        end
    end
    
    % If we have a refund, sum values of all purchases after each 
    % refund ('value2') by finding indices where the customer
    % subsequently purchases an item
    value2 = 0;
    for i = find(refunds)
        after = zeros(1,rows);
        refundID = C{i,2};
        for j = i+1:rows
            if (C{j,2} == refundID)&&(C{j,6} == 'N') 
                after(j) = 1;
            end
        end
        for k = find(after)
            value2 = value2 + C{k,4};
        end
    end
    
    %(1) total values during the four-year period
    %(2) total values spent after a refund
    %(3) percentage comparison
    v = [value,value2,(value2/value)*100];    
end