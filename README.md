# evil-nft

This is a template of an NFT collection that tests the security of NFT marketplaces. 
To deploy the smart contract, run `npx hardhat run scripts/deploy.js`. Adjust the network settings in hardhat.config.js.

To deploy NFT metadata with security tests, you may use vercel.com. Just fork this repo, connect your GitHub account at Vercel and the metadata will be deployed automatically.
Don't forget to change URLs in public/api/ using this command:
```
grep -rl 'evil-nft.vercel.app' * | xargs -i@ sed -i 's/evil-nft.vercel.app/your.attack.domain/g' @
```