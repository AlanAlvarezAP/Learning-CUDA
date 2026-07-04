#pragma once

#include <iostream>
#include <chrono>
#include <iomanip>

typedef std::chrono::steady_clock reloj;

class Timer {
private:
	reloj::time_point ini,fin;
	double elapsed;

public:
	void start_time() {
		ini = reloj::now();
	}

	void end_time() {
		fin = reloj::now();
	}

	void print_diff(const std::string& type_prueba) {
		elapsed = std::chrono::duration_cast<std::chrono::microseconds>(fin - ini).count();
		
		std::cout << std::setw(50) << std::setfill('=') << '\n';
		std::cout << "|" << " Resultados de las pruebas CUDA de " << type_prueba << "|" << '\n';
		std::cout << "|" << " Tiempo final: " << elapsed << " us" << "|" << '\n';
		std::cout << std::setw(50) << std::setfill('=') << '\n';

		ini = {};
		fin = {};
		elapsed = 0.0;
	}

};