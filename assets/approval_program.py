from pyteal import *

def approval_program():
    """
    This smart contract implements a stateful counter
    """
    var_counter = Bytes("counter")
    counter = App.globalGet(var_counter)

    init_counter = Seq([
        App.globalPut(var_counter, Int(0)),
        Return(Int(1))
    ])

    increment = Seq([
        App.globalPut(var_counter, counter + Int(1)),
        Return(Int(1))
    ])

    program = Cond(
        [Txn.application_id() == Int(0), init_counter],
        [Txn.on_completion() == OnComplete.NoOp, increment],
        [Int(1), Return(Int(1))]
    )

    return program

if __name__ == "__main__":
    print(compileTeal(approval_program(), Mode.Application, version=5))
