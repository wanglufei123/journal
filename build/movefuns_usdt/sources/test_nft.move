module movefuns_usdt::test_nft{

    use sui::url::{Self,Url};
    use std::string;
    use sui::object::{Self,ID,UID};
    use sui::event;
    use sui::transfer;
    use sui::tx_context::{Self,TxContext};

    struct TestNft has key,store{
            id:UID,
            name: string::String,
            description: string::String,
            url: Url,
    }

    struct NftMint has  copy,drop {
        object_id: ID,
        creator: address,
        name: string::String,
    }  

    public fun name(nft: &TestNft): &string::String {
        &nft.name
    }

    public fun description(nft: &TestNft): &string::String {
        &nft.description
    }

    public fun url(nft: &TestNft): &Url {
        &nft.url
    }

    public entry fun mint_to_sender(
        name: vector<u8>,
        description: vector<u8>,
        url: vector<u8>,
        ctx: &mut TxContext
    ){

        let sender = tx_context::sender(ctx);
        let nft = TestNft {
            id: object::new(ctx),
            name: string::utf8(name),
            description: string::utf8(description),
            url: url::new_unsafe_from_bytes(url)
        };

        event::emit(NftMint{
            object_id: object::id(&nft),
            creator: sender,
            name: nft.name,
        });

        transfer::public_transfer(nft,sender);

    }

    public entry fun transfer(
        nft: TestNft,recipient: address,_: &mut TxContext
    ){
        transfer::public_transfer(nft,recipient)
    }

    public entry fun update_description(
        nft: &mut TestNft,
        new_description: vector<u8>,
        _: &mut TxContext
    ){
        nft.description = string::utf8(new_description)
    }

    public entry fun burn(
        nft: TestNft,_: &mut TxContext
    ){
        let TestNft{id,name:_,description:_,url:_}=nft;
        object::delete(id)
    }



//0xf02410feba3a32180034075087d30d95e30a5859e36362e6539f9e596f7db47b

// sui.exe client call --package 0xf02410feba3a32180034075087d30d95e30a5859e36362e6539f9e596f7db47b --module test_nft --function mint_to_sender --gas-budget 100000000 --args "one" "one is description" "https://github.githubassets.com/favicons/favicon.png"


}