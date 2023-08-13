# superhack-2023

work repo for superhack 2023 hackathon

The SuperhackOFTV2Fee token is deployed to 3 networks that are connected in a triangle set up so that  
you can only send the tokens like this:

```
         fuji
          ^ \
         /   \
        /     \
       /       v
    mumbai <- sepolia

```

Transaction has a fee that can be quoted like this:   
`npx hardhat --network mumbai-polygon oftFeeQuote --targetnetwork fuji --contract SuperhackOFTV2Fee --qty 100`

## deploy notes

```javascript
npx hardhat --network fuji deploy --contract SuperhackOFTV2Fee
```

### fuji

Deploying SuperhackOFTV2Fee...
deploying "SuperhackOFTV2Fee" (tx: 0xff0823be44ca2c563bdcf9563c1d961617eeddedcdaa7bde3f78147b27eb4159)...: deployed at 0xb9277033a24008bA819c7F9863317601C6bdB12F with 4220672 gas
Deployed!

npx hardhat --network fuji setTrustedRemote --target-network sepolia --contract
SuperhackOFTV2Fee
✅ [fuji] setTrustedRemote(10161, 0xb9277033a24008ba819c7f9863317601c6bdb12fb9277033a24008ba819c7f9863317601c6bdb12f)
tx: 0x5cfcf6bf0036f1fd2555d6461985c57b58dcdf6f4e35875fcef5efe000e7aac8

npx hardhat --network fuji oftFeeSetBp --fee 666 --targetnetwork sepolia --contract SuperhackOFTV2Fee
tx: 0x0cdcc7886ef68b969230f76093697f1b8a3d272da241695a2dc64fdb577d5454

### sepolia

Deploying SuperhackOFTV2Fee...
deploying "SuperhackOFTV2Fee" (tx: 0xc8bcb65f6f1453a55749002de22692f8279bd60f5b24c5c5066adddeddd3cbb1)...: deployed at 0xb9277033a24008bA819c7F9863317601C6bdB12F with 4221942 gas
Deployed!

npx hardhat --network sepolia setTrustedRemote --target-network mumbai-polygon --contract SuperhackOFTV2Fee
✅ [sepolia] setTrustedRemote(10109, 0xb9277033a24008ba819c7f9863317601c6bdb12fb9277033a24008ba819c7f9863317601c6bdb12f)
tx: 0x286d8a3c530de07e7a9be3d78e38b2ce875a6424f190ca3b3bcccd3ea5e6a2a8

npx hardhat --network sepolia oftFeeSetBp --fee 666 --targetnetwork mumbai-polygon --contract SuperhackOFTV2Fee
tx: 0x2d5fb3af6b8434661b10072118ffcf5ad91b149612423086f3bca9c4fbbeef29

### mumbai

Deploying SuperhackOFTV2Fee...
deploying "SuperhackOFTV2Fee" (tx: 0x40b626868985c8d70a94dcdb22170f28aff4c066b0ae2f5d390b5a46776baf6a)...: deployed at 0xb9277033a24008bA819c7F9863317601C6bdB12F with 4220672 gas
Deployed!

npx hardhat --network mumbai-polygon setTrustedRemote --target-network fuji --contract SuperhackOFTV2Fee
✅ [mumbai-polygon] setTrustedRemote(10106, 0xb9277033a24008ba819c7f9863317601c6bdb12fb9277033a24008ba819c7f9863317601c6bdb12f)
tx: 0x6c7dc93be5771e151c0d1a9bf72b44efbcae12808ccaffa7ad308bf67c1a86be

npx hardhat --network mumbai-polygon oftFeeSetBp --fee 666 --targetnetwork fuji --contract SuperhackOFTV2Fee
tx: 0xdec8ea7303bd18d26ea1e6de290b0670355f36bb73576b4cee621d3dd50d1e15
