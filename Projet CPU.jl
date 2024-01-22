### A Pluto.jl notebook ###
# v0.19.27

using Markdown
using InteractiveUtils

# ╔═╡ cffc6036-a345-4083-b6cf-35fe1ec76cec
begin
	using Pkg
	cd(joinpath(dirname(@__FILE__),".."))
	Pkg.activate(pwd())
    using ResumableFunctions
	using Logging
	using PlutoUI
	using Images
	TableOfContents()

end

# ╔═╡ ab40b318-8ee6-4a34-af13-0dfa5e57f4c4
html"""
 <! -- this adapts the width of the cells to display its being used on -->
<style>
	main {
		margin: 0 auto;
		max-width: 2000px;
    	padding-left: max(160px, 10%);
    	padding-right: max(160px, 10%);
	}
</style>
"""

# ╔═╡ ff4f41e2-d0d6-4446-901a-6dda4105b9f5
url_image = "https://www.cise.ufl.edu/~mssz/CompOrg/Figure4.3-MIPSarch2.gif";

# ╔═╡ df90b735-af40-4830-853d-fc608f279453
md""" # Central Processing Unit """

# ╔═╡ 4af5aae0-99c6-41fe-8716-34e2b2cb2b30
const Adresse = Dict(1 => "\$zero", 2 => "\$v0", 3 => "\$s1" , 4 => "\$s0" , 5 => "\$a2", 6 => "\$s2")

# ╔═╡ 0521fd8f-f6da-4897-a47b-0414f031eba8
mutable struct Processor 
	Reg :: Array{Int64, 1}   
	pc ::Int64
	IM :: Array{String, 1}
end

# ╔═╡ dc7d354b-7cdb-4ba7-9245-07519c75c1a7
function Base.print(io::IO, P::Processor)
@info ("[$(Adresse[1]),$(Adresse[2]),$(Adresse[3]),$(Adresse[4]),$(Adresse[5]),$(Adresse[6]) ] --> $(P.Reg)")
end 

# ╔═╡ 0d8376ec-0364-4aaa-8258-917483b6d531
begin 
	url = "https://www.researchgate.net/profile/Yul-Chu/publication/228942202/figure/fig2/AS:669511661412368@1536635427816/Instruction-formats-for-MIPS-architecture-1.png"
md""" $(Resource(url, :width => 500))"""

end 

# ╔═╡ b0b66f1e-de82-4e2f-91e4-f369b8153b0e
md""" # Instruction Fetch """

# ╔═╡ d9218171-9530-4b0f-925c-7adf504c131b
function fetch(P:: Processor)
    instruction = P.IM[P.pc]
	@info "l'instruction $(P.pc) est déterminée"
    return instruction
end


# ╔═╡ b6cb8ead-85ca-4e4b-90ac-2ef7f530f69f
md""" # Instruction Decode """

# ╔═╡ 39c5b9c2-363c-40aa-9428-803cfa98a7ff
function decode(P::Processor,instruction)
	opcode = instruction[1:6]
	if opcode == "000000"
		rs = instruction[7:11]
		rt = instruction[12:16]
	    rd = instruction[17:21]
		sh = instruction[22:26]
		funct = instruction[27:32]
		@info "l'instruction $(P.pc) est décodée"
	return  (opcode, rs , rt, rd, sh, funct)
	elseif opcode != "000000"#opcode non r-type only immediate considered
		rs = instruction[7:11]
		rt = instruction[12:16]
		immediate = instruction[17:32]
		@info "l'instruction $(P.pc) est décodée"
		return (opcode, rs,rt,immediate)
	end
end 

# ╔═╡ 6e5c4fe7-68eb-4f80-9722-a47283c4db3e
md""" # Arithmetic and Logic Unit"""

# ╔═╡ 98743bf4-83e4-4870-8203-4438b3f5fc7d
md""" $(Resource(url_image, :width => 800))"""

# ╔═╡ bfdd63c4-971a-4292-897f-d28a52fdc101
md""" # Instructions memory"""

# ╔═╡ 6da2f133-aeec-4a9c-bbe6-132cb60d60c7
begin 

	function jump(P,k)
	a = P.pc;
	P.pc += (k-a)
	end

	function J(target)
		opcode = "000010"
		t = bitstring(parse(Int, "$(target)", base =10))[end-25:end]
		return opcode*t[1:5]*t[6:10]*t[11:end]
	end 

	function beq(rs,rt,offset)
		opcode = "000100" #BEQ
		a = bitstring(parse(Int, "$(rs)", base =10))[end-4:end]
		b = bitstring(parse(Int, "$(rt)", base =10))[end-4:end]
		c = bitstring(parse(Int, "$(offset)", base =10))[end-15:end]
		return opcode*a*b*c
	end

	function addi(rs,rt,immediate)
		opcode = "001000"
		a = bitstring(parse(Int, "$(rs)", base =10))[end-4:end]
		b = bitstring(parse(Int, "$(rt)", base =10))[end-4:end]
		c = bitstring(parse(Int, "$(immediate)", base =10))[end-15:end]
		return opcode*a*b*c
	end

	function addi(rs,rt,immediate)
		opcode = "001000"
		a = bitstring(parse(Int, "$(rs)", base =10))[end-4:end]
		b = bitstring(parse(Int, "$(rt)", base =10))[end-4:end]
		c = bitstring(parse(Int, "$(immediate)", base =10))[end-15:end]
		return opcode*a*b*c
	end

	function mul(rs,rt,rd)
		opcode = "000000"
		func = "011000"
		sh = "00000"
		a = bitstring(parse(Int, "$(rs)", base =10))[end-4:end]
		b = bitstring(parse(Int, "$(rt)", base =10))[end-4:end]
		c = bitstring(parse(Int, "$(rd)", base =10))[end-4:end]
		return opcode*a*b*c*sh*func
	end

	function sub(rs,rt,rd)
		opcode = "000000"
		func = "100010"
		sh = "00000"
		a = bitstring(parse(Int, "$(rs)", base =10))[end-4:end]
		b = bitstring(parse(Int, "$(rt)", base =10))[end-4:end]
		c = bitstring(parse(Int, "$(rd)", base =10))[end-4:end]
		return opcode*a*b*c*sh*func
	end
end 

# ╔═╡ d598e788-e097-4bf8-b6db-6faecfbaf0a3
begin 

	function execute(proc, code)
	i = parse(Int, code[2], base = 2);
	j = parse(Int, code[3], base = 2);
	k = parse(Int, code[4], base = 2);
	if code[1] =="000000" #R-type
			if code[end] == "100000" #ADD
				proc.Reg[k] = proc.Reg[i] + proc.Reg[j]
				@info " $(Adresse[i]) +  $(Adresse[j]) --> $(Adresse[k]) " 
				print(proc)
		
			elseif code[end] == "011000" #MUL
				proc.Reg[k] = proc.Reg[i] * proc.Reg[j]
				@info " $(Adresse[i]) *  $(Adresse[j]) --> $(Adresse[k])" 
				print(proc)
			elseif code[end] == "100010" #SUB
				proc.Reg[k] = proc.Reg[i] - proc.Reg[j]
				@info " $(Adresse[i]) - $(Adresse[j]) --> $(Adresse[k]) " 
				print(proc)
			end 
	elseif code[1] =="001000" #ADDI
		proc.Reg[j] = proc.Reg[i] + parse(Int, code[end], base = 2)
		@info " $(Adresse[i]) +  $(parse(Int, code[end], base = 2)) --> $(Adresse[j])" 
		print(proc)
		
	elseif code[1] == "000100" #BEQ
		if proc.Reg[i] == proc.Reg[j]
			@info " $(Adresse[i]) == $(Adresse[j]) =>  PC --> $(k)" 
			print(proc) 
        	return  jump(proc,k) 
   		 end
		@info " $(Adresse[i]) != $(Adresse[j]) =>  PC est incrémenté "  
		print(proc) 
	elseif code[1] == "000010" #JUMP
			proc.pc = k
		return @info " Jump de la valeur de PC --> $(k) "
	end 
	 proc.pc += 1 
	@info "La valeur de PC est incrémentée à $(proc.pc)"
end 
	
end 

# ╔═╡ a43074de-8a17-41a8-b1bc-c262b4462a7c
function run(proc)
	while proc.pc <= length(proc.IM)
		I = fetch(proc)
		code = decode(proc,I)
		execute(proc,code)
	end 
	
end 
	

# ╔═╡ af070415-8ccc-4adc-8482-1515c7716209
md""" # Fonction factorial """

# ╔═╡ 15dceef8-2075-43fe-834d-67229e856107
begin 
	
function initial(n)
	
	In1 = addi(1,5,n)
	
	In2 = addi(5,4,0)
	
	In3 = addi(1,6,1)
	In4 = addi(1,3,1)
	@info "les valeurs des registres sont initialisées"
	return [In1,In2,In3,In4 ]
end 
	
function instruction_fact(P::Processor,n)
	x = P.pc
	I1 = beq(4,1,x+4)
	
	I2 = mul(3,4,3)
	I3 = sub(4,6,4)
	I4 = J(x)
	I5 = addi(3,2,0)
	return [I1,I2,I3,I4,I5]

end 

@resumable function fact(P::Processor,n)	
	A = initial(n)
	P.IM = [(P.IM)..., A...]
	@yield run(P)
 	B = instruction_fact(P,n)
	P.IM = [(P.IM)..., B...]
	run(P)
end 
	
end 

# ╔═╡ 5ba344c0-b6d9-40d1-a927-7cf9f4fa3db5
processor = Processor(zeros(Int64,6),1,[])

# ╔═╡ 5daa0f3d-46da-42ee-b91a-7a07483e36f7
B = fact(processor,5);

# ╔═╡ 06155bb8-86e4-4ad4-99c8-4c1c7219b301
B()

# ╔═╡ 635c1d14-95d7-4270-961a-ff727cd02a61
function affiche()
md""" 

| Registres | valeurs |
| ----------- | ----------- |
| $(Adresse[1])  |  $(processor.Reg[1])|
| $(Adresse[2])  |  $(processor.Reg[2])|
| $(Adresse[4])  |  $(processor.Reg[4])|
| $(Adresse[5])  |  $(processor.Reg[5])|
| $(Adresse[6])  |  $(processor.Reg[6])|

"""
end ;

# ╔═╡ e7a13559-b7d9-4610-aff9-b943f2cdf0f7
affiche()

# ╔═╡ 1fe1510b-e90b-41c9-aa02-d070fd5dd691
function EX(proc, code)
	i = parse(Int, code[2], base = 2);
	j = parse(Int, code[3], base = 2);
	k = parse(Int, code[4], base = 2);
	if code[1] =="000000" #R-type
			if code[end] == "100000" #ADD
				proc.registers[k] = proc.registers[i] + proc.registers[j]
			elseif code[end] == "101010"  #SLT
				if proc.registers[i] < proc.registers[j]
					proc.registers[k] == 1
				else
					proc.registers[k] == 0
				end 
			elseif code[end] == "011000" #MUL
				proc.registers[k] = proc.registers[i] * proc.registers[j]
			elseif code[end] == "100010" #SUB
				proc.registers[k] = proc.registers[i] - proc.registers[j]
			elseif code[end] == "100100" #AND
				proc.registers[k] = proc.registers[i] & proc.registers[j]
			elseif code[end] == "011010" #DIV	
				proc.registers[k] = proc.registers[i] / proc.registers[j]
			elseif code[end] == "100111" #NOR	
				proc.registers[k] = nor(proc.registers[i],proc.registers[j])
			elseif code[end] == "100101" #OR	
				proc.registers[k] = proc.registers[i] | proc.registers[j]
			elseif code[end] == "100110" #XOR	
				proc.registers[k] = xor(proc.registers[i],proc.registers[j])
			end 
	elseif code[1] =="001000" #ADDI
		proc.registers[j] = proc.registers[i] + parse(Int, code[end], base = 2)
		
	elseif code[1] == "000100" #BEQ
		if proc.registers[i] == proc.registers[j]
        	return jump(proc,k) 
   		 end
	end 
	 proc.pc += 1 
	@info "l'instruction est exécutée et la valeur de PC est incrémentée"
end;

# ╔═╡ Cell order:
# ╟─ab40b318-8ee6-4a34-af13-0dfa5e57f4c4
# ╟─cffc6036-a345-4083-b6cf-35fe1ec76cec
# ╟─ff4f41e2-d0d6-4446-901a-6dda4105b9f5
# ╟─df90b735-af40-4830-853d-fc608f279453
# ╠═4af5aae0-99c6-41fe-8716-34e2b2cb2b30
# ╠═0521fd8f-f6da-4897-a47b-0414f031eba8
# ╠═dc7d354b-7cdb-4ba7-9245-07519c75c1a7
# ╟─0d8376ec-0364-4aaa-8258-917483b6d531
# ╟─b0b66f1e-de82-4e2f-91e4-f369b8153b0e
# ╠═d9218171-9530-4b0f-925c-7adf504c131b
# ╟─b6cb8ead-85ca-4e4b-90ac-2ef7f530f69f
# ╠═39c5b9c2-363c-40aa-9428-803cfa98a7ff
# ╟─6e5c4fe7-68eb-4f80-9722-a47283c4db3e
# ╠═d598e788-e097-4bf8-b6db-6faecfbaf0a3
# ╟─98743bf4-83e4-4870-8203-4438b3f5fc7d
# ╟─bfdd63c4-971a-4292-897f-d28a52fdc101
# ╠═6da2f133-aeec-4a9c-bbe6-132cb60d60c7
# ╠═a43074de-8a17-41a8-b1bc-c262b4462a7c
# ╟─af070415-8ccc-4adc-8482-1515c7716209
# ╠═15dceef8-2075-43fe-834d-67229e856107
# ╠═5ba344c0-b6d9-40d1-a927-7cf9f4fa3db5
# ╠═5daa0f3d-46da-42ee-b91a-7a07483e36f7
# ╠═06155bb8-86e4-4ad4-99c8-4c1c7219b301
# ╟─635c1d14-95d7-4270-961a-ff727cd02a61
# ╠═e7a13559-b7d9-4610-aff9-b943f2cdf0f7
# ╟─1fe1510b-e90b-41c9-aa02-d070fd5dd691
