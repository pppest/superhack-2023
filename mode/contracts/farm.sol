// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

interface IModeShack {
    function mint(address to, uint256 amount) external;
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    function burn(uint256 amount) external;
    function burnFrom(address account, uint256 amount) external;
    function decimals() external view returns (uint8);
    function name() external view returns (string memory);
    function symbol() external view returns (string memory);
    function owner() external view returns (address);
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}


contract ShackFarm is Ownable {
    using SafeMath for uint256;
    
    // Info of each user.
    struct UserInfo {
        uint256 amount;     // How many LP tokens the user has provided.
        uint256 rewardDebt; // Reward debt. See explanation below.
        //
        // We do some fancy math here. Basically, any point in time, the amount of DRUGs
        // entitled to a user but is pending to be distributed is:
        //
        //   pending reward = (user.amount * pool.accTokenPerShare) - user.rewardDebt
        //
        // Whenever a user deposits or withdraws LP tokens to a pool. Here's what happens:
        //   1. The pool's `accTokenPerShare` (and `lastRewardBlock`) gets updated.
        //   2. User receives the pending reward sent to his/her address.
        //   3. User's `amount` gets updated.
        //   4. User's `rewardDebt` gets updated.
    }

    // Info of each pool.
    struct PoolInfo {
        IModeShack lpToken;           // Address of LP token contract.
        uint256 allocPoint;       // How many allocation points assigned to this pool. DRUGs to distribute per block.
        uint256 lastRewardBlock;  // Last block number that DRUGs distribution occurs.
        uint256 accTokenPerShare; // Accumulated DRUGs per share, times 1e12. See below.
    }

    mapping(address => bool) public isTokenAdded;

    // Reward Token
    IModeShack public rewardToken;
    
    // farm parameters
    address public devAddr;
    uint256 public tokenPerBlock;
    uint256 public BONUS_MULTIPLIER = 1;
    uint256 public farmFee = 1000000 ether;
    uint256 public allocationFee = 100000 ether;
    uint256 public defaultAllocation = 10;
    uint256 public defaultAllocationIncrease = 1;



    // Info of each pool.
    PoolInfo[] public poolInfo;
    // Info of each user that stakes LP tokens.
    mapping (uint256 => mapping (address => UserInfo)) public userInfo;
    // Total allocation poitns. Must be the sum of all allocation points in all pools.
    uint256 public totalAllocPoint = 0;
    // The block number when token mining starts.
    uint256 public startBlock;

    event Deposit(address indexed user, uint256 indexed pid, uint256 amount);
    event Withdraw(address indexed user, uint256 indexed pid, uint256 amount);
    event EmergencyWithdraw(address indexed user, uint256 indexed pid, uint256 amount);

    constructor(
        IModeShack _rewardToken
    )  {
        rewardToken = _rewardToken;
        devAddr = msg.sender;
        tokenPerBlock = 1000 ether;
        startBlock = block.number;

        // staking pool
        poolInfo.push(PoolInfo({
            lpToken: _rewardToken,
            allocPoint: 1000,
            lastRewardBlock: startBlock,
            accTokenPerShare: 0
        }));

        totalAllocPoint = 1000;

    }

    function updateMultiplier(uint256 multiplierNumber) public onlyOwner {
        BONUS_MULTIPLIER = multiplierNumber;
    }

    function poolLength() external view returns (uint256) {
        return poolInfo.length;
    }

    function isTokenAlreadyAdded(address _token) external view returns (bool) {
        return isTokenAdded[_token];
    }
    function add( IModeShack _lpToken, bool _withUpdate) public {
        require(!isTokenAdded[address(_lpToken)], "Token already added as a pool");
        require(rewardToken.transferFrom(msg.sender, address(this), farmFee),"Must pay to add!");
        rewardToken.burn(farmFee);
        
        if (_withUpdate) {
            massUpdatePools();
        }
        uint256 lastRewardBlock = block.number > startBlock ? block.number : startBlock;
        totalAllocPoint = totalAllocPoint.add(defaultAllocation);

        poolInfo.push(PoolInfo({
            lpToken: _lpToken,
            allocPoint: defaultAllocation,
            lastRewardBlock: lastRewardBlock,
            accTokenPerShare: 0
        }));

        isTokenAdded[address(_lpToken)] = true; // Mark the token as added
        updateStakingPool();
    }

    // Update the given pool's token allocation point. Can only be called by the owner.
    function set(uint256 _pid,  bool _withUpdate) public  {
        require(rewardToken.transferFrom(msg.sender, address(devAddr), allocationFee),"Must pay to set!");  
        rewardToken.burn(allocationFee);

        if (_withUpdate) {
            massUpdatePools();
        }

        totalAllocPoint = totalAllocPoint.add(defaultAllocationIncrease);
        
        poolInfo[_pid].allocPoint =  poolInfo[_pid].allocPoint.add(defaultAllocationIncrease);
        updateStakingPool();
    }

    function updateStakingPool() internal {
        uint256 length = poolInfo.length;

        uint256 points = 0;

        for (uint256 pid = 1; pid < length; ++pid) {
            points = points.add(poolInfo[pid].allocPoint);
        }

        if (points != 0) {
            points = points.div(4);
            totalAllocPoint = totalAllocPoint.sub(poolInfo[0].allocPoint).add(points);
            poolInfo[0].allocPoint = points;
        }
    }

    // Return reward multiplier over the given _from to _to block.
    function getMultiplier(uint256 _from, uint256 _to) public view returns (uint256) {
        return _to.sub(_from).mul(BONUS_MULTIPLIER);
    }

    // View function to see pending DRUGs on frontend.
    function pendingToken(uint256 _pid, address _user) external view returns (uint256) {
        PoolInfo storage pool = poolInfo[_pid];
        UserInfo storage user = userInfo[_pid][_user];
        uint256 accTokenPerShare = pool.accTokenPerShare;
        uint256 lpSupply = pool.lpToken.balanceOf(address(this));
      
        if (block.number > pool.lastRewardBlock && lpSupply != 0) {
            uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
            uint256 tokenReward = multiplier.mul(tokenPerBlock).mul(pool.allocPoint).div(totalAllocPoint);
            accTokenPerShare = accTokenPerShare.add(tokenReward.mul(1e12).div(lpSupply));
        }
      
        return user.amount.mul(accTokenPerShare).div(1e12).sub(user.rewardDebt);
    }

    // Update reward variables for all pools. Be careful of gas spending!
    function massUpdatePools() public {
        uint256 length = poolInfo.length;
        for (uint256 pid = 0; pid < length; ++pid) {
            updatePool(pid);
        }
    }


    // Update reward variables of the given pool to be up-to-date.
    function updatePool(uint256 _pid) public {
        PoolInfo storage pool = poolInfo[_pid];
        if (block.number <= pool.lastRewardBlock) {
            return;
        }
        uint256 lpSupply = pool.lpToken.balanceOf(address(this));
        if (lpSupply == 0) {
            pool.lastRewardBlock = block.number;
            return;
        }
        uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
        uint256 tokenReward = multiplier.mul(tokenPerBlock).mul(pool.allocPoint).div(totalAllocPoint);
       
        rewardToken.mint(devAddr, tokenReward.div(10));
       
        pool.accTokenPerShare = pool.accTokenPerShare.add(tokenReward.mul(1e12).div(lpSupply));
        pool.lastRewardBlock = block.number;
    }

    // Deposit LP tokens to ShackFarm for token allocation.
    function deposit(uint256 _pid, uint256 _amount) public {
        PoolInfo storage pool = poolInfo[_pid];
        UserInfo storage user = userInfo[_pid][msg.sender];
        updatePool(_pid);
        if (user.amount > 0) {
            uint256 pending = user.amount.mul(pool.accTokenPerShare).div(1e12).sub(user.rewardDebt);
            if(pending > 0) {
                rewardToken.mint(msg.sender, pending);
            }
        }
        if (_amount > 0) {
            uint256 lpFee = _amount.div(100);
            uint256 afterFee = _amount.sub(lpFee);
            pool.lpToken.transferFrom(address(msg.sender), address(devAddr), lpFee);
            pool.lpToken.transferFrom(address(msg.sender), address(this), afterFee);
            user.amount = user.amount.add(afterFee);

            user.rewardDebt = user.amount.mul(pool.accTokenPerShare).div(1e12);
            emit Deposit(msg.sender, _pid, afterFee);
        } else {
            user.rewardDebt = user.amount.mul(pool.accTokenPerShare).div(1e12);
            emit Deposit(msg.sender, _pid, _amount);
        }
    }

    // Withdraw LP tokens from ShackFarm.
    function withdraw(uint256 _pid, uint256 _amount) public {
        PoolInfo storage pool = poolInfo[_pid];
        UserInfo storage user = userInfo[_pid][msg.sender];
        require(user.amount >= _amount, "withdraw: not good");

        updatePool(_pid);
        uint256 pending = user.amount.mul(pool.accTokenPerShare).div(1e12).sub(user.rewardDebt);
      
        if(pending > 0) {
            rewardToken.mint(msg.sender, pending);
        }
      
        if(_amount > 0) {
            user.amount = user.amount.sub(_amount);
            pool.lpToken.transfer(address(msg.sender), _amount);
        }
        user.rewardDebt = user.amount.mul(pool.accTokenPerShare).div(1e12);
      
        emit Withdraw(msg.sender, _pid, _amount);
    }


    // Withdraw without caring about rewards. EMERGENCY ONLY.
    function emergencyWithdraw(uint256 _pid) public {
        PoolInfo storage pool = poolInfo[_pid];
        UserInfo storage user = userInfo[_pid][msg.sender];
        pool.lpToken.transfer(address(msg.sender), user.amount);
        
        emit EmergencyWithdraw(msg.sender, _pid, user.amount);
        
        user.amount = 0;
        user.rewardDebt = 0;
    }

    // Update dev address
    function dev(address _devAddr) public onlyOwner {
        devAddr = _devAddr;
    }
    // Update LP Fee Address
    function devAddress(address _devAddr) public onlyOwner {
        devAddr = _devAddr;
    }
}