require "pp"

git_dir = '/vendor/msysgit/libexec/git-core/'
working_dir = Dir.pwd
Dir.chdir(working_dir + git_dir)
Dir.entries('.').each do |file|
	if file.end_with?('.exe') and not (file == 'git.exe' or file == 'mergetools' or file.end_with?('.bat'))
		File.open(File.basename(file, '.*') + '.bat', "w") do |new_file|
			new_file.write('@' + File.basename(file, '.*').gsub('-',' ') + ' $*')
		end
		puts 'Deleting: ' + file
		File.delete(file)
		next
	end
end

