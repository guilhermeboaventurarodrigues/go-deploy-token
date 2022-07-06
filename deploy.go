package main

import (
	"fmt"
	"log"
	"github.com/ethereum/go-ethereum/accounts/abi/bind"
	"github.com/ethereum/go-ethereum/ethclient"
	"github.com/ethereum/go-ethereum/crypto"
	"math/big"
	"crypto/ecdsa"
	"context"
	token "github.com/guilhermeboaventurarodrigues/token-go/tokens"
)

func main() {

client, err := ethclient.Dial("HTTP://127.0.0.1:7545") //IP GANACHE
	if err != nil {
		log.Fatal(err)
	}

	fmt.Println("we have a connection")
	_ = client

	privateKey, err := crypto.HexToECDSA("170c05471c13cde237a066e52deb893999d566dd548182da2f06770ee872e2b5") // PRIVATE KEY

	publicKey := privateKey.Public()
	publicKeyECDSA, ok := publicKey.(*ecdsa.PublicKey)
	if !ok {
		log.Fatal("error casting public key to EDCSA")
	}

	fromAddress := crypto.PubkeyToAddress(*publicKeyECDSA)
	nonce, err := client.PendingNonceAt(context.Background(), fromAddress)
	if err != nil {
		log.Fatal(err)
	}

	gasPrice, err := client.SuggestGasPrice(context.Background())
	if err != nil {
		log.Fatal(err)
	}

	auth := bind.NewKeyedTransactor(privateKey)
	auth.Nonce = big.NewInt(int64(nonce))
	auth.Value = big.NewInt(0)
	auth.GasLimit = uint64(6721975)
	auth.GasPrice = gasPrice

	address, tx, instance, err := token.DeployToken(auth, client) 
	if err != nil{
		log.Fatal(err)
	}

	fmt.Println(address.Hex()) // Address of contract
	fmt.Println(tx.Hash().Hex()) //Address of transaction

	_ = instance

}