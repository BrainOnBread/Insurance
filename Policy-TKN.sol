pragma solidity ^0.4.24;

import ".erc721-insure.sol";

contract Policy is ERC721, MinterRole {
    
    struct PolicyId {
        uint256 tokenId;
        address to;
        address insured_address;
        string cover_item;
        uint cover_payout;
        uint cover_limit;
        uint weekly_premium;
    }    
    
    struct Request {
        uint reqid;
        string cover_item;
        address insured;
    }
    
    struct Bid {
        address possible_owner;
        uint256 weekly_premium;
        uint reqid;
        uint cover_limit;
        uint cover_payout;
    }
    
    Bid[] public bids;
    Request[] public requests;
    PolicyId[] public policies;
    
    function mint(
        address to, 
        uint256 tokenId, 
        address insured_address, 
        string cover_item, 
        uint cover_payout, 
        uint cover_limit, 
        uint weekly_premium
    ) 
        public onlyMinter returns (bool) 
    {
        
        _mint(to, tokenId);
        
        PolicyId memory newPolicy = PolicyId(
            tokenId,
            to,
            insured_address,
            cover_item,
            cover_payout,
            cover_limit,
            weekly_premium
        );
        
        policies.push(newPolicy);
        
        return true;
    }
 
    function submit_req(
        address insured_address, 
        string cover_item, 
        uint reqid
    ) 
        public
    {
    
        require(insured_address != 0);
        require(reqid != 0);
    
        Request memory newRequest = Request(
            reqid,
            cover_item,
            insured_address
        );
    
        requests.push(newRequest);
    }

    function _submit_bid(
        uint reqid, 
        uint cover_limit, 
        uint cover_payout, 
        uint weekly_premium, 
        address possible_owner
    )
        public 
    {
        require(requests[reqid].reqid != 0);
        
        Bid memory newBid = Bid(
            possible_owner,
            weekly_premium,
            reqid,
            cover_limit,
            cover_payout
        );
    
        Request storage newRequest = requests[reqid];
        bids.push(newBid);
    }
    
}
