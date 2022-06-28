from brownie import SWAgreement, config, accounts, network

def deployed():

    #Network Ganache
    if (network.show_active() == "development"):
        admin = accounts[0]
    #Networks ETH
    else:
        admin = accounts.add(config["wallets"]["from_key"])

    print ('Wallet (Wei): ', admin.balance())

    ss = SWAgreement.deploy ({"from": admin}) 
    print ('address contract:', ss)
    ss.addRequirement("HU1","I as ... want ... because")
    print (ss.getRequirement("HU1"))
    ss.addRequirement("HU2","I as ... want ... because")
    print (ss.getRequirement("HU2"))
    ss.addRequirement("HU3","I as ... want ... because")
    print (ss.getRequirement("HU3"))
    ss.updateRequirement("HU3","We as ... want ... because")
    print (ss.getRequirement("HU3"))
    ss.acceptanceRequirement ("HU2")
    print (ss.getRequirement("HU2"))
    print ("Pay requirement HU1 x 122.34 USD (24.06.22) = 0.1 ETH")
    ss.fundAccount({"from": ss.client(), "value": 100000000000000000})

    #print ('Rate ETH/USD :',ss.getConversionRate(1))

    #print ('Pay > 50 USD :', ss.validateMinimumPay(51))

    #print ('client:', ss.developer())

    #print ('address:', ss)

    return ss

    """
    <
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

def main():
    deployed()