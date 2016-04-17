#include <iostream>
#include <iomanip>
#include <string>

using namespace std;

enum controls {
	LD_MAR, LD_MDR, LD_IR, LD_BEN, LD_REG, LD_CC, LD_PC, LD_Priv, 
	LD_SavedSSP, LD_SavedUSP, LD_Vector,
	GatePC, GateMDR, GateALU, GateMARMUX, GateVector, GatePCm1, GatePSR, GateSP
};

struct microinstruction {
	//bool IRD;
	//bool Cond[3];
	//bool J[6];

	string comment;

	bool control[19];

	bool PCMUX[2];
	bool DRMUX[2];
	bool SR1MUX[2];
	bool ADDR1MUX;
	bool ADDR2MUX[2];
	bool SPMUX[2];
	bool MARMUX;
	bool VectorMUX[2];
	bool PSRMUX;
	bool ALUK[2];
	bool MIO_EN;
	bool R_W;
	bool Set_Priv;
	//Where is SR2MUX ???

	void displayArray(bool *arr, int x) {
		// Print controls
		cout << ' ';
		for (int i = 0; i < x; i++) {
			cout << arr[i];
		}
	}

	void display() {
		displayArray(control, 19);
		displayArray(PCMUX, 2);
		displayArray(DRMUX, 2);
		displayArray(SR1MUX, 2);
		cout << ' ' << ADDR1MUX;
		displayArray(ADDR2MUX, 2);
		displayArray(SPMUX, 2);
		cout << ' ' << MARMUX;
		displayArray(VectorMUX, 2);
		cout << ' ' << PSRMUX;
		displayArray(ALUK, 2);
		cout << ' ' << MIO_EN;
		cout << ' ' << R_W;
		cout << ' ' << Set_Priv;
		if (comment.size()) cout << ' ' << "//" << comment;
	}
	
	void setControl() {}
	template<typename Arg1, typename ...Args> 
	void setControl(const Arg1& arg1, const Args&... args) {
		control[arg1] = 1;
		setControl(args...);
	}

};

void setArray(bool *arr, string s) {
	//Assumes that array size == s.size()
	for (unsigned int i = 0; i < s.size(); i++) {
		arr[i] = (s.at(i) == '1') ? 1 : 0;
	}
}

int main() {

	microinstruction states[64] = {microinstruction()}; //Initialize to 0
	
	states[0].comment = "BR";

	states[1].comment = "ADD";
	states[1].setControl(LD_REG, LD_CC, GateALU);
	setArray(states[1].DRMUX, "00");
	setArray(states[1].SR1MUX, "01");
	setArray(states[1].ALUK, "00");

	states[2].comment = "LD";
	states[2].setControl(LD_MAR, LD_CC);
	setArray(states[2].DRMUX, "00");

	states[3].comment = "ST";
	states[3].setControl(LD_MAR, GatePC);
	setArray(states[3].ADDR2MUX, "10");

	states[4].comment = "JSR";
	states[4].setControl(LD_REG, GatePC);
	setArray(states[4].DRMUX, "10");
	setArray(states[4].PCMUX, "00");

	states[5].comment = "AND";
	states[5].setControl(LD_REG, LD_CC, GateALU);
	setArray(states[5].DRMUX, "00");
	setArray(states[5].SR1MUX, "01");
	setArray(states[5].ALUK, "01");

	states[6].comment = "LDR";
	states[6].setControl(LD_MAR);
	setArray(states[6].DRMUX, "00");
	setArray(states[6].ADDR2MUX, "01");

	states[7].comment = "STR";

	states[8].comment = "RTI";
	states[8].setControl(LD_MAR, GateSP);

	states[9].comment = "NOT";
	states[9].setControl(LD_REG, LD_CC, GateALU);
	setArray(states[9].DRMUX, "00");
	setArray(states[9].SR1MUX, "01");
	setArray(states[9].ALUK, "10");

	states[10].comment = "LDI";
	states[10].setControl(LD_CC);
	setArray(states[10].DRMUX, "00");

	states[11].comment = "STI";

	states[12].comment = "JMP";

	states[13].setControl(LD_MDR, GatePSR);

	states[14].comment = "LEA";
	states[14].setControl(LD_REG, LD_CC, GatePC);
	setArray(states[14].DRMUX, "00");
	setArray(states[14].ADDR2MUX, "10");
	states[14].ADDR1MUX = 1;

	states[15].comment = "TRAP";

	states[16].setControl(GateMDR);
	states[16].MIO_EN = 1;
	states[16].R_W = 1;

	states[18].setControl(LD_MAR, LD_PC, GatePC);
	states[18].R_W = 1;
	setArray(states[18].PCMUX, "00");

	states[24].setControl(LD_MDR);
	states[24].MIO_EN = 1;
	states[24].R_W = 1;

	states[25].setControl(LD_MDR);
	states[25].MIO_EN = 1;
	states[25].R_W = 1;

	states[26].setControl(LD_MAR, GateMDR);
	states[27].setControl(LD_REG, LD_CC, GateALU);
	states[30].setControl(LD_PC, GateMDR);
	states[31].setControl(LD_MAR, GateMDR);
	states[32].setControl(LD_BEN);

	states[33].setControl(LD_MDR);
	states[33].MIO_EN = 1;
	states[33].R_W = 1;

	states[35].setControl(LD_IR, GateMDR);

	states[36].setControl(LD_MDR);
	states[36].MIO_EN = 1;
	states[36].R_W = 1;

	states[38].setControl(LD_PC, GateMDR);

	states[40].setControl(LD_MDR);
	states[40].MIO_EN = 1;
	states[40].R_W = 1;

	states[44].setControl(LD_MDR, GatePSR);

	states[52].setControl(LD_MDR);
	states[52].MIO_EN = 1;
	states[52].R_W = 1;



	for (int i = 0; i < 64; i++) {
		cout << '@' << setfill('0') << setw(2) << std::hex << i << ' ';
		states[i].display();
		cout << endl;
	}

	return 0;
}