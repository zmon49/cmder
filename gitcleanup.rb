require 'pp'
require 'digest/md5'

git_dir = '/vendor/msysgit/libexec/git-core/'
working_dir = Dir.pwd
Dir.chdir(working_dir + git_dir)

def md5 filename
    Digest::MD5.hexdigest(File.read(filename))
end

clone_md5 = md5('git.exe')
puts 'Md5 of the clones is: ' + clone_md5

Dir.glob('*.exe').each do |file|
    if file != 'git.exe' and md5(file) == clone_md5
        command = file.match(/git-(.*).exe/)[1]
        filename = file.split('.')[0] + '.bat'
        File.write(filename, '@git ' + command + ' $*') unless File.exists?(filename)
        File.delete(file)
    end
end

Dir.chdir(working_dir)