import {
  Approval as ApprovalEvent,
  CallOFTReceivedSuccess as CallOFTReceivedSuccessEvent,
  MessageFailed as MessageFailedEvent,
  NonContractAddress as NonContractAddressEvent,
  OwnershipTransferred as OwnershipTransferredEvent,
  ReceiveFromChain as ReceiveFromChainEvent,
  RetryMessageSuccess as RetryMessageSuccessEvent,
  SendToChain as SendToChainEvent,
  SetDefaultFeeBp as SetDefaultFeeBpEvent,
  SetFeeBp as SetFeeBpEvent,
  SetFeeOwner as SetFeeOwnerEvent,
  SetMinDstGas as SetMinDstGasEvent,
  SetPrecrime as SetPrecrimeEvent,
  SetTrustedRemote as SetTrustedRemoteEvent,
  SetTrustedRemoteAddress as SetTrustedRemoteAddressEvent,
  SetUseCustomAdapterParams as SetUseCustomAdapterParamsEvent,
  Transfer as TransferEvent
} from "../generated/SuperhackOFTV2Fee/SuperhackOFTV2Fee"
import {
  Approval,
  CallOFTReceivedSuccess,
  MessageFailed,
  NonContractAddress,
  OwnershipTransferred,
  ReceiveFromChain,
  RetryMessageSuccess,
  SendToChain,
  SetDefaultFeeBp,
  SetFeeBp,
  SetFeeOwner,
  SetMinDstGas,
  SetPrecrime,
  SetTrustedRemote,
  SetTrustedRemoteAddress,
  SetUseCustomAdapterParams,
  Transfer
} from "../generated/schema"

export function handleApproval(event: ApprovalEvent): void {
  let entity = new Approval(
    event.transaction.hash.concatI32(event.logIndex.toI32())
  )
  entity.owner = event.params.owner
  entity.spender = event.params.spender
  entity.value = event.params.value

  entity.blockNumber = event.block.number
  entity.blockTimestamp = event.block.timestamp
  entity.transactionHash = event.transaction.hash

  entity.save()
}

export function handleCallOFTReceivedSuccess(
  event: CallOFTReceivedSuccessEvent
): void {
  let entity = new CallOFTReceivedSuccess(
    event.transaction.hash.concatI32(event.logIndex.toI32())
  )
  entity._srcChainId = event.params._srcChainId
  entity._srcAddress = event.params._srcAddress
  entity._nonce = event.params._nonce
  entity._hash = event.params._hash

  entity.blockNumber = event.block.number
  entity.blockTimestamp = event.block.timestamp
  entity.transactionHash = event.transaction.hash

  entity.save()
}

export function handleMessageFailed(event: MessageFailedEvent): void {
  let entity = new MessageFailed(
    event.transaction.hash.concatI32(event.logIndex.toI32())
  )
  entity._srcChainId = event.params._srcChainId
  entity._srcAddress = event.params._srcAddress
  entity._nonce = event.params._nonce
  entity._payload = event.params._payload
  entity._reason = event.params._reason

  entity.blockNumber = event.block.number
  entity.blockTimestamp = event.block.timestamp
  entity.transactionHash = event.transaction.hash

  entity.save()
}

export function handleNonContractAddress(event: NonContractAddressEvent): void {
  let entity = new NonContractAddress(
    event.transaction.hash.concatI32(event.logIndex.toI32())
  )
  entity._address = event.params._address

  entity.blockNumber = event.block.number
  entity.blockTimestamp = event.block.timestamp
  entity.transactionHash = event.transaction.hash

  entity.save()
}

export function handleOwnershipTransferred(
  event: OwnershipTransferredEvent
): void {
  let entity = new OwnershipTransferred(
    event.transaction.hash.concatI32(event.logIndex.toI32())
  )
  entity.previousOwner = event.params.previousOwner
  entity.newOwner = event.params.newOwner

  entity.blockNumber = event.block.number
  entity.blockTimestamp = event.block.timestamp
  entity.transactionHash = event.transaction.hash

  entity.save()
}

export function handleReceiveFromChain(event: ReceiveFromChainEvent): void {
  let entity = new ReceiveFromChain(
    event.transaction.hash.concatI32(event.logIndex.toI32())
  )
  entity._srcChainId = event.params._srcChainId
  entity._to = event.params._to
  entity._amount = event.params._amount

  entity.blockNumber = event.block.number
  entity.blockTimestamp = event.block.timestamp
  entity.transactionHash = event.transaction.hash

  entity.save()
}

export function handleRetryMessageSuccess(
  event: RetryMessageSuccessEvent
): void {
  let entity = new RetryMessageSuccess(
    event.transaction.hash.concatI32(event.logIndex.toI32())
  )
  entity._srcChainId = event.params._srcChainId
  entity._srcAddress = event.params._srcAddress
  entity._nonce = event.params._nonce
  entity._payloadHash = event.params._payloadHash

  entity.blockNumber = event.block.number
  entity.blockTimestamp = event.block.timestamp
  entity.transactionHash = event.transaction.hash

  entity.save()
}

export function handleSendToChain(event: SendToChainEvent): void {
  let entity = new SendToChain(
    event.transaction.hash.concatI32(event.logIndex.toI32())
  )
  entity._dstChainId = event.params._dstChainId
  entity._from = event.params._from
  entity._toAddress = event.params._toAddress
  entity._amount = event.params._amount

  entity.blockNumber = event.block.number
  entity.blockTimestamp = event.block.timestamp
  entity.transactionHash = event.transaction.hash

  entity.save()
}

export function handleSetDefaultFeeBp(event: SetDefaultFeeBpEvent): void {
  let entity = new SetDefaultFeeBp(
    event.transaction.hash.concatI32(event.logIndex.toI32())
  )
  entity.feeBp = event.params.feeBp

  entity.blockNumber = event.block.number
  entity.blockTimestamp = event.block.timestamp
  entity.transactionHash = event.transaction.hash

  entity.save()
}

export function handleSetFeeBp(event: SetFeeBpEvent): void {
  let entity = new SetFeeBp(
    event.transaction.hash.concatI32(event.logIndex.toI32())
  )
  entity.dstchainId = event.params.dstchainId
  entity.enabled = event.params.enabled
  entity.feeBp = event.params.feeBp

  entity.blockNumber = event.block.number
  entity.blockTimestamp = event.block.timestamp
  entity.transactionHash = event.transaction.hash

  entity.save()
}

export function handleSetFeeOwner(event: SetFeeOwnerEvent): void {
  let entity = new SetFeeOwner(
    event.transaction.hash.concatI32(event.logIndex.toI32())
  )
  entity.feeOwner = event.params.feeOwner

  entity.blockNumber = event.block.number
  entity.blockTimestamp = event.block.timestamp
  entity.transactionHash = event.transaction.hash

  entity.save()
}

export function handleSetMinDstGas(event: SetMinDstGasEvent): void {
  let entity = new SetMinDstGas(
    event.transaction.hash.concatI32(event.logIndex.toI32())
  )
  entity._dstChainId = event.params._dstChainId
  entity._type = event.params._type
  entity._minDstGas = event.params._minDstGas

  entity.blockNumber = event.block.number
  entity.blockTimestamp = event.block.timestamp
  entity.transactionHash = event.transaction.hash

  entity.save()
}

export function handleSetPrecrime(event: SetPrecrimeEvent): void {
  let entity = new SetPrecrime(
    event.transaction.hash.concatI32(event.logIndex.toI32())
  )
  entity.precrime = event.params.precrime

  entity.blockNumber = event.block.number
  entity.blockTimestamp = event.block.timestamp
  entity.transactionHash = event.transaction.hash

  entity.save()
}

export function handleSetTrustedRemote(event: SetTrustedRemoteEvent): void {
  let entity = new SetTrustedRemote(
    event.transaction.hash.concatI32(event.logIndex.toI32())
  )
  entity._remoteChainId = event.params._remoteChainId
  entity._path = event.params._path

  entity.blockNumber = event.block.number
  entity.blockTimestamp = event.block.timestamp
  entity.transactionHash = event.transaction.hash

  entity.save()
}

export function handleSetTrustedRemoteAddress(
  event: SetTrustedRemoteAddressEvent
): void {
  let entity = new SetTrustedRemoteAddress(
    event.transaction.hash.concatI32(event.logIndex.toI32())
  )
  entity._remoteChainId = event.params._remoteChainId
  entity._remoteAddress = event.params._remoteAddress

  entity.blockNumber = event.block.number
  entity.blockTimestamp = event.block.timestamp
  entity.transactionHash = event.transaction.hash

  entity.save()
}

export function handleSetUseCustomAdapterParams(
  event: SetUseCustomAdapterParamsEvent
): void {
  let entity = new SetUseCustomAdapterParams(
    event.transaction.hash.concatI32(event.logIndex.toI32())
  )
  entity._useCustomAdapterParams = event.params._useCustomAdapterParams

  entity.blockNumber = event.block.number
  entity.blockTimestamp = event.block.timestamp
  entity.transactionHash = event.transaction.hash

  entity.save()
}

export function handleTransfer(event: TransferEvent): void {
  let entity = new Transfer(
    event.transaction.hash.concatI32(event.logIndex.toI32())
  )
  entity.from = event.params.from
  entity.to = event.params.to
  entity.value = event.params.value

  entity.blockNumber = event.block.number
  entity.blockTimestamp = event.block.timestamp
  entity.transactionHash = event.transaction.hash

  entity.save()
}
