namespace Quantum.QSharpApplication {
    open Microsoft.Quantum.Convert;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Intrinsic;

    @EntryPoint() 
    operation Main(): Unit {
        SuperPosition();
        TestBellState();
        RandomNumberGenerator();
        FactorizeWithGrovers(200);
    }

    operation SuperPosition() : Unit {
        use qs = Qubit[2];
        for qubit in qs {
            H(qubit);
        }
        let res = M(qs[0]);
        let res2 = M(qs[1]);

        Message($"SuperPosition: {res}, {res2}");
    }

    operation TestBellState() : Unit {
        use (q0, q1) = (Qubit(), Qubit());
        H(q0);
        CNOT(q0, q1);
        let res = M(q0);
        let res2 = M(q1);

        Message($"TestBellState: q0 = {res} q1 = {res2}");
    }

    operation RandomNumberGenerator() : Unit {
        mutable output = new Int[3];
        use q = Qubit() {
            for i in 0 .. 2 {    
                H(q);
                let m = M(q);
                let bit = m == Zero ? 0 | 1;
                set output w/= i <- bit;
            }
	    }    
        let result = convertBitArrayToInt(output);
        Message($"RandomNumberGenerator: {result}");
	}

    operation convertBitArrayToInt(array: Int[]) : Int {
        mutable loopLap = 0;
        mutable result = 0;
        for i in array {
            set result += i * 2^loopLap;
            set loopLap += 1;
        }

        return result;
    }
}
