/* index the reservation stations as well as the LS_buffers entries
 * zero indicates that value inside the regisiter file is valid
 * LS_buff0 = 1
 * LS_buff1 = 2
 * LS_buff2 = 3
 * LS_buff3 = 4
 * LS_buff4 = 5
 * LS_buff5 = 6
 * ADD_rs0 = 7
 * ADD_rs0 = 8
 * ADD_rs0 = 9
 * MUL_rs0 = 10
 * MUL_rs0 = 11
 * no reservation station = 12
 *
 *
 *
 * */
/*	
 * LW  imm[11:0]       rs1   010     rd    0000011
 * SW  imm[11:5]       rs1   010   imm[4:0]0100011
 *      funct7   rs2   rs1   funct3   rd   opcode
 * ADD  0000000              000           0110011
 * SUB  0100000              000           0110011
 * MUL  0000001              000           0110011
 * DIV  0000001              100           0110011
 *
 *
 * */


/* operations
 * operation = 0 , ADD
 * operation = 1 , SUB
 * operation = 2 , MUL
 * operation = 3 , DIV
 * operation = 4 , LOAD
 * operation = 5 , STORE
*/


/*
*/



