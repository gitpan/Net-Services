use ExtUtils::MakeMaker;
WriteMakefile(
    NAME		=> 'Net::Services',
    VERSION_FROM	=> 'lib/Net/Services.pm',
    PREREQ_PM => {
		'Pod::Coverage' => 0.11,
		'Module::Info' => 0.12,
		'Test::More' => 0.41,
		'IO::File' => 1.08,
	    },
        ($] >= 5.005 ?    ## Add these new keywords supported since 5.005
      (ABSTRACT_FROM => 'lib/Net/Services.pm', # retrieve abstract from module
      AUTHOR     => 'Iain Truskett <spoon@cpan.org>') : ()),
);


