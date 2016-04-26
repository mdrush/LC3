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

	void displayArray(bool *arr, int x) {
		// Print controls
		//cout << ' ';
		for (int i = 0; i < x; i++) {
			cout << arr[i];
		}
	}

	void display() {
		displayArray(control, 19);
		displayArray(PCMUX, 2);
		displayArray(DRMUX, 2);
		displayArray(SR1MUX, 2);
		cout << ADDR1MUX;
		displayArray(ADDR2MUX, 2);
		displayArray(SPMUX, 2);
		cout << MARMUX;
		displayArray(VectorMUX, 2);
		cout << PSRMUX;
		displayArray(ALUK, 2);
		cout << MIO_EN;
		cout << R_W;
		cout << Set_Priv;
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
	states[2].setControl(LD_MAR, GateMARMUX);
	setArray(states[2].DRMUX, "00");
	setArray(states[2].ADDR2MUX, "10");
	states[2].MARMUX = 1;

	states[3].comment = "ST";
	states[3].setControl(LD_MAR, GateMARMUX);
	setArray(states[3].ADDR2MUX, "10");
	states[3].MARMUX = 1;

	states[4].comment = "JSR";
	states[4].setControl(LD_REG, GatePC);
	setArray(states[4].DRMUX, "01");
	setArray(states[4].PCMUX, "00");

	states[5].comment = "AND";
	states[5].setControl(LD_REG, LD_CC, GateALU);
	setArray(states[5].DRMUX, "00");
	setArray(states[5].SR1MUX, "01");
	setArray(states[5].ALUK, "01");

	states[6].comment = "LDR";
	states[6].setControl(LD_MAR, GateMARMUX);
	setArray(states[6].DRMUX, "00");
	setArray(states[6].SR1MUX, "01");
	setArray(states[6].ADDR2MUX, "01");
	states[6].ADDR1MUX = 1;
	states[6].MARMUX = 1;

	states[7].comment = "STR";
	states[7].setControl(LD_MAR, GateMARMUX);
	setArray(states[7].DRMUX, "00");
	setArray(states[7].SR1MUX, "01");
	setArray(states[7].ADDR2MUX, "01");	
	states[7].ADDR1MUX = 1;
	states[7].MARMUX = 1;

	states[8].comment = "RTI";
	states[8].setControl(LD_MAR, GateALU);
	setArray(states[8].SR1MUX, "10");
	setArray(states[8].ALUK, "11");

	states[9].comment = "NOT";
	states[9].setControl(LD_REG, LD_CC, GateALU);
	setArray(states[9].DRMUX, "00");
	setArray(states[9].SR1MUX, "01");
	setArray(states[9].ALUK, "10");

	states[10].comment = "LDI";
	states[10].setControl(LD_MAR, GateMARMUX);
	setArray(states[10].ADDR2MUX, "10");
	states[10].MARMUX = 1;

	states[11].comment = "STI";
	states[11].setControl(LD_MAR, GateMARMUX);
	setArray(states[11].ADDR2MUX, "10");
	states[11].MARMUX = 1;

	states[12].comment = "JMP";
	states[12].setControl(LD_PC);
	setArray(states[12].PCMUX, "10");
	setArray(states[12].SR1MUX, "01");
	states[12].ADDR1MUX = 1;

	states[13].setControl(LD_MDR, LD_Priv, LD_Vector, GatePSR);
	setArray(states[13].VectorMUX, "10");

	states[14].comment = "LEA";
	states[14].setControl(LD_REG, LD_CC, GateMARMUX);
	setArray(states[14].DRMUX, "00");
	setArray(states[14].ADDR2MUX, "10");
	states[14].MARMUX = 1;

	states[15].comment = "TRAP";
	states[15].setControl(LD_MAR, GateMARMUX);

	states[16].MIO_EN = 1;
	states[16].R_W = 1;

	states[18].setControl(LD_MAR, LD_PC, GatePC);
	setArray(states[18].PCMUX, "00");

	states[20].setControl(LD_REG, LD_PC, GatePC);
	setArray(states[20].PCMUX, "10");
	setArray(states[20].DRMUX, "01");
	setArray(states[20].SR1MUX, "01");
	states[20].ADDR1MUX = 1;

	states[21].setControl(LD_PC);
	setArray(states[21].PCMUX, "10");
	setArray(states[21].ADDR2MUX, "11");

	states[22].setControl(LD_PC);
	setArray(states[22].PCMUX, "10");
	setArray(states[22].ADDR2MUX, "10");

	states[23].setControl(LD_MDR, GateALU);
	setArray(states[23].ALUK, "11");

	states[24].setControl(LD_MDR);
	states[24].MIO_EN = 1;

	states[25].setControl(LD_MDR);
	states[25].MIO_EN = 1;

	states[26].setControl(LD_MAR, GateMDR);

	states[27].setControl(LD_REG, LD_CC, GateMDR);

	states[28].setControl(LD_MDR, LD_REG, GatePC);
	setArray(states[28].DRMUX, "01");
	states[28].MIO_EN = 1;

	states[29].setControl(LD_MDR);
	states[29].MIO_EN = 1;

	states[30].setControl(LD_PC, GateMDR);
	setArray(states[30].PCMUX, "01");

	states[31].setControl(LD_MAR, GateMDR);
	states[32].setControl(LD_BEN);

	states[33].setControl(LD_MDR);
	states[33].MIO_EN = 1;

	states[34].setControl(LD_REG, GateSP);
	setArray(states[34].DRMUX, "10");
	setArray(states[34].SR1MUX, "10");

	states[35].setControl(LD_IR, GateMDR);

	states[36].setControl(LD_MDR);
	states[36].MIO_EN = 1;

	states[37].setControl(LD_MAR, LD_REG, GateSP);
	setArray(states[37].DRMUX, "10");
	setArray(states[37].SR1MUX, "10");
	setArray(states[37].SPMUX, "01");

	states[38].setControl(LD_PC, GateMDR);
	setArray(states[38].PCMUX, "01");

	states[39].setControl(LD_MAR, LD_REG, GateSP);
	setArray(states[39].DRMUX, "10");
	setArray(states[39].SR1MUX, "10");

	states[40].setControl(LD_MDR);
	states[40].MIO_EN = 1;

	states[41].PSRMUX = 1;
	states[41].MIO_EN = 1;
	states[41].R_W = 1;

	states[42].setControl(LD_CC, LD_Priv, GateMDR);

	states[43].setControl(LD_MDR, GatePCm1);

	states[44].setControl(LD_MDR, LD_Priv, LD_Vector, GatePSR);
	setArray(states[44].VectorMUX, "01");

	states[45].setControl(LD_REG, LD_SavedUSP, GateSP);
	setArray(states[45].DRMUX, "10");
	setArray(states[45].SR1MUX, "10");
	setArray(states[45].SPMUX, "10");

	states[47].setControl(LD_MAR, LD_REG, GateSP);
	setArray(states[47].DRMUX, "10");
	setArray(states[47].SR1MUX, "10");
	setArray(states[47].SPMUX, "10");

	states[48].MIO_EN = 1;
	states[48].R_W = 1;

	states[49].setControl(LD_MDR, LD_Priv, LD_Vector, GatePSR);

	states[50].setControl(LD_MAR, GateVector);

	states[52].setControl(LD_MDR);
	states[52].MIO_EN = 1;

	states[54].setControl(LD_PC, GateMDR);
	setArray(states[54].PCMUX, "01");

	states[59].setControl(LD_REG, LD_SavedSSP, GateSP);
	setArray(states[59].DRMUX, "10");
	setArray(states[59].SR1MUX, "10");
	setArray(states[59].SPMUX, "11");


	for (int i = 0; i < 64; i++) {
		cout << '@' << setfill('0') << setw(2) << std::hex << i << ' ';
		states[i].display();
		cout << endl;
	}

	return 0;
}