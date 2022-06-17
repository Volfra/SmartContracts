from brownie import SWAgreement, config, accounts, network

def main():

    #Network Ganache
    if (network.show_active() == "development"):
        admin = accounts[0]
    #Networks ETH
    else:
        admin = accounts.add(config["wallets"]["from_key"])

    print ('Wallet (Wei): ', admin.balance())

    ss = SWAgreement.deploy ({"from": admin}) 

    print ('Rate ETH/USD :',ss.getConversionRate(1))

    print ('Pay > 50 USD :', ss.validateMinimumPay(51))

    print ('developer:',ss.developer())

    print ('client:', ss.client())

    """
    
    ss.initTime()

    i = ss.beginTime()

    ss.endTime()

    f = ss.finishTime()

    ss.showTotalTime(i, f)
    
    print ('totalTime:',ss.totalTime())

    print ('cost:',ss.cost())

    print ('nowTime:',ss.nowTime())
    
    print ('developer:',ss.developer())

    print ('version:',ss.getVersion())

 """