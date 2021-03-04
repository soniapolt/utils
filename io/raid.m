function raidDir = raid
if onLaptop
    if isdir('/Volumes/projects-6/')
        raidDir = '/Volumes/projects-6/';
    else
        raidDir = '/Volumes/projects/';
    end
else
    raidDir = '/share/kalanit/biac2/kgs/projects/'; end
end
