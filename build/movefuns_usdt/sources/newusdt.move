module movefuns_usdt::newusdt{

    use sui::tx_context::TxContext;
    use sui::coin;
    use sui::coin::TreasuryCap;
    use sui::transfer;
    use std::option;
    use sui::url;
    use sui::tx_context;
    use sui::object::{Self,UID};
    use std::string;

    struct NEWUSDT has drop{}

    fun init(witness: NEWUSDT ,ctx: &mut TxContext){

        let (cap, metadata) = coin::create_currency(witness,9,b"O",b"OOO",b"OOOOOOO",option::some(url::new_unsafe_from_bytes(b"https://github.githubassets.com/favicons/favicon.png")),ctx);

        transfer::public_transfer(cap,tx_context::sender(ctx));
        transfer::public_freeze_object(metadata);

    }

    public entry fun mint_me(cap: &mut TreasuryCap<NEWUSDT>, amount: u64, ctx: &mut TxContext){

        let coin_usdt=coin::mint(cap,amount,ctx);
        transfer::public_transfer(coin_usdt,tx_context::sender(ctx));

    }

    public entry fun mint_to(cap: &mut TreasuryCap<NEWUSDT>, amount: u64,to: address, ctx: &mut TxContext){

        let coin_usdt=coin::mint(cap,amount,ctx);
        transfer::public_transfer(coin_usdt,to);

    }

    struct HelloWorldObject has key,store{
        id:UID,
        text: string::String
    }

    public entry fun mint_text(text: vector<u8>,ctx: &mut TxContext){

            let object = HelloWorldObject {
                id: object::new(ctx),
                text: string::utf8(text)
            };

            transfer::transfer(object,tx_context::sender(ctx));

    }

}