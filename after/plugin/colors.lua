function ColorMyPencils(color)

	color = color or "arctic";
	vim.cmd.colorscheme(color);
end

ColorMyPencils();
