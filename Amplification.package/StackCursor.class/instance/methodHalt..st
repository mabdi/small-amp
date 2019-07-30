as yet unclassified
methodHalt: anInt
	Transcript
		show: anInt;
		tab;
		show: thisContext sender pc;
		tab;
		show: (thisContext sender method sourceNodeForPC: thisContext sender pc);
		cr