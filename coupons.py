import numpy as np
import pandas as pd

def ismember(k, d):
    temp = [1 if (i == k) else 0 for i in d]
    if sum(temp) > 0:
        return True
    else:
        return False

def coupons(filename):
    df = pd.read_csv(filename, index_col='Customer_ID', parse_dates=['Date'])

    customers = list()
    for i in df.index.values:
        if not ismember(i,customers):
            customers.append(i)

    # Electrics will be product category 'D'
    numberElectrics = list()
    totalElectrics = list()
    numberReviews = list()
    totalReviews = list()
    for p in customers:
        numberElectric = 0
        totalElectric = 0
        numberReview = 0
        totalReview = 0
        currentDF = df.loc[p]
        for i in range(len(currentDF)):
            if currentDF.iloc[i,1] == 'D':
                numberElectric += 1
                totalElectric += currentDF.iloc[i,2]
            numberReview += 1
            totalReview += currentDF.iloc[i,3]
        numberElectrics.append(numberElectric)
        totalElectrics.append(totalElectric)
        numberReviews.append(numberReview)
        totalReviews.append(totalReview)

    avgElectrics = list()
    avgReviews = list()
    for i in range(len(numberReviews)):
        if totalElectrics[i] != 0:
            avgElectrics.append(totalElectrics[i]/numberElectrics[i])
        else:
            avgElectrics.append(0)
        if totalReviews[i] != 0:
            avgReviews.append(totalReviews[i]/numberReviews[i])
        else:
            avgReviews.append(0)

    colnames = ['Customer ID', '# of Electrics Bought',
    'Total Value of Electrics', 'Avg Electrics Value', '# of Reviews',
    'Total Reviews Score', 'Avg Review Score']
    data = pd.DataFrame(list(zip(customers, numberElectrics,
            totalElectrics, avgElectrics, numberReviews,
            totalReviews, avgReviews)), columns=colnames)

    data2 = data.transpose()
    data2.to_csv('data.csv')

    """
    Create a list of weighted score to find customers with the best average
    electrics spend and also average rating score. 11.5538 will properly scale
    the ratings so they are measured as equal to the electrics purchases
    """
    weightedScore = list()
    for i in range(len(avgElectrics)):
        weightedScore.append(avgElectrics[i] + 11.5538*avgReviews[i])

    # Now return a list of the top100 customer IDs together with their score
    top100Scores = list()
    top100Indexes = list()
    top100 = list()
    c = 0
    while c < 100:
        for i in range(len(weightedScore)):
            if weightedScore[i] == max(weightedScore):
                top100Scores.append(weightedScore[i])
                top100Indexes.append(i)
                weightedScore[i] = -1
                break
        top100.append(customers[i])
        c += 1

    return list(zip(top100, top100Scores))

print(coupons('purchasing_order.csv'))
