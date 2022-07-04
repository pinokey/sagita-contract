const main = async () => {
    const [owner] = await hre.ethers.getSigners();
    const sagitaContractFactory = await hre.ethers.getContractFactory("sagitaPortal")
    const sagitaContract = await sagitaContractFactory.deploy();
    const sagitaPortal = await sagitaContract.deployed();
  
    console.log(" SagitaPortal address: ", sagitaPortal.address);
    console.log("Contract deployed by:", owner.address);
    // let Edgelists = await sagitaContract.getAllEdges();
    // let EdgeTxn  = await sagitaContract.addEdge("https://opensea.io/collection/very-long-animals", "0xC52d9642260830055c986a97794B7b27393Edf5e", "https://opensea.io/collection/verylongroboticsanimals" ,"", []);
    // EdgeTxn  = await sagitaContract.addEdge("https://opensea.io/collection/very-long-animals", "0xC52d9642260830055c986a97794B7b27393Edf5e", "https://opensea.io/collection/veryverylonganimals" ,"", []);
    // Edgelists = await sagitaContract.getAllEdges();
    let EdgeTxn  = await sagitaContract.addEdge("Very Long Animals", "https://opensea.io/collection/very-long-animals", "0xC52d9642260830055c986a97794B7b27393Edf5e", "very long robotics animals", "https://opensea.io/collection/verylongroboticsanimals" ,"", []);
    EdgeTxn  = await sagitaContract.addEdge("Very Long Animals", "https://opensea.io/collection/very-long-animals", "0xC52d9642260830055c986a97794B7b27393Edf5e", "very very long animals", "https://opensea.io/collection/veryverylonganimals" ,"", []);
    // console.log("edgelist", Edgelists);
    // let addvalidater = await sagitaContract.upsertValidator(owner.address);
    // addvalidater = await sagitaContract.upsertValidator(randomPerson.address);
    
    let addvalidater = await sagitaContract.upsertValidator(owner.address);
    // await addvalidater.wait();
    // addvalidater = await sagitaContract.upsertValidator(randomPerson.address);
    let validaters = await sagitaContract.getAllValidators();
    // await validaters.wait();
    console.log("validaters : ", validaters); 
    // let approve =  await sagitaContract.approve(0);
    // Edgelists = await sagitaContract.getAllEdges();
    // console.log("edgelist", Edgelists);

    //何で頭につくのか問題を解決できていない
    //何でvalidatorが表示されないのかもデバッグ必要あり
    
  };
  
  const runMain = async () => {
    try {
      await main();
      process.exit(0);
    } catch (error) {
      console.log(error);
      process.exit(1);
    }
  };
  
  runMain();