from brownie import SWAgreement
from scripts.deploy import deployed

#contract = deployed()
contract = SWAgreement[-1]

def fund():
    print ('Address contract deployed: ',contract)     
    print(f"The current value ETH is {contract.getConversionRate(1)} USD")
    account = contract.client()
    print('from address: ',account)
    tx = contract.fundAccount({"from": account, "value": 10000000000000000})
    print (tx)

def withdraw():
    tx = contract.withdrawAccount()
    print (tx)

def main():
    fund()
    #withdraw()