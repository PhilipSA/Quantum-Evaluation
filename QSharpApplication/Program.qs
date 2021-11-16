namespace Quantum.QSharpApplication {
    open Microsoft.Quantum.Diagnostics;
    open Microsoft.Quantum.Arrays;
    open Microsoft.Quantum.Convert;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Intrinsic;

    @EntryPoint() 
    operation Main(): Unit {
        SuperPosition();
        BellState();
        RandomNumberGenerator();

        //Oracles
        let notSeven = isSeven([true, true, false]);
        Message($"Not seven: {notSeven}");
        let seven = isSeven([true, true, true]);
        Message($"Seven: {seven}");

        use qsPhase = Qubit[3] {
            ApplyToEachA(H, qsPhase);
            //If seven all Qbits are flipped to 0 ket
            isSeven_PhaseOracle(qsPhase);

            mutable outputString = "Qbit values: ";
            for qbit in qsPhase {
                let result = M(qbit);
                set outputString += $"{result},";
            }
            Message(outputString);
            ResetAll(qsPhase);
	    }

        use qsMark = Qubit[3] {
            use qsMarker = Qubit() {
                ApplyToEachA(H, qsMark);
                //If seven marker is set to 1 ket
                isSeven_MarkingOracle(qsMark, qsMarker);
                let result = M(qsMarker);
                Message($"Marker value: {result}");
                Reset(qsMarker);
	        }
            ResetAll(qsMark);
	    }

        //FactorizeWithGrovers(200);
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

    operation BellState() : Unit {
        use (q0, q1) = (Qubit(), Qubit());
        H(q0);
        CNOT(q0, q1);
        let res = M(q0);
        let res2 = M(q1);

        Message($"BellState: q0 = {res} q1 = {res2}");
    }

    operation RandomNumberGenerator() : Unit {
        mutable output = new Bool[3];
        use q = Qubit() {
            for i in 0 .. 2 {    
                H(q);
                let m = M(q);
                let bit = m == One ? true | false;
                set output w/= i <- bit;
            }
	    }    
        let result = BoolArrayAsInt(output);
        Message($"RandomNumberGenerator: {result}");
	}

    function isSeven(x: Bool[]) : Bool {
        return BoolArrayAsInt(x) == 7;
    }

    operation isSeven_PhaseOracle (x : Qubit[]) : Unit is Adj + Ctl {
        Controlled Z(Most(x), Tail(x));
    }

    operation isSeven_MarkingOracle (x : Qubit[], y : Qubit) : Unit is Adj + Ctl {
        Controlled X(x, y);
    }
}
