#include <iostream>

void setBackground(unsigned r, unsigned g, unsigned b)
{
	std::cout << "\x1b[48;2;" << r << ';' << g << ';' << b << 'm';
}

int main()
{
	int point[4][3] = {	{255,0,0},
						{0,255,0},
						{0,0,255},
						{0,0,0}};

	int r = 0, g = 0, b = 0;
	int defStepsLeft = 80/4;
	int stepsLeft = defStepsLeft;
	int currPoint = 0;

	int mr = (point[0][0]-r)/defStepsLeft, mg = (point[0][1]-g)/defStepsLeft, mb = (point[0][2]-b)/defStepsLeft;
	for(unsigned step = 0;step < 80;++ step)
	{
		setBackground(r, g, b);
		std::cout << ' ';

		r += mr;
		g += mg;
		b += mb;
		stepsLeft --;

		if(stepsLeft == 0)
		{
			stepsLeft = defStepsLeft;
			currPoint ++;
			mr = (point[currPoint][0]-r)/defStepsLeft;
			mg = (point[currPoint][1]-g)/defStepsLeft;
			mb = (point[currPoint][2]-b)/defStepsLeft;
		}
	}
	std::cout << std::endl;
	return 0;
}