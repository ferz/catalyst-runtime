use strict;
use warnings;
use inc::Module::Install 0.91;
# Ensure that these get used - yes, M::I loads them for us, but if you're
# in author mode and don't have them installed, then the error is tres
# cryptic.
if ($Module::Install::AUTHOR) { # We could just use them, but telling
    my @fail;                   # people the set of things they need nicer
    foreach my $module (qw/
        Module::Install::AuthorRequires
        Module::Install::CheckConflicts
        Module::Install::AuthorTests
        Module::Install::Authority
    /) {
        push(@fail, $module)
            unless eval qq{require $module; 1;};
    }
    die("Module::Install extensions failed, not installed? \n"
        . join("\n", map { "  $_" } @fail) . "\n") if @fail;
}

perl_version '5.008003';

name 'Catalyst-Runtime';
author 'Sebastian Riedel <sri@cpan.org>';
authority('cpan:MSTROUT');
all_from 'lib/Catalyst/Runtime.pm';

requires 'List::Util' => '1.45';
requires 'namespace::autoclean' => '0.28';
requires 'namespace::clean' => '0.23';
requires 'MooseX::Emulate::Class::Accessor::Fast' => '0.00903';
requires 'Class::Load' => '0.12';
requires 'Data::OptList';
requires 'Moose' => '1.03';
requires 'MooseX::MethodAttributes::Role::AttrContainer::Inheritable' => '0.24';
requires 'MooseX::Role::WithOverloading' => '0.09' unless can_use('Moose', '2.1300');
requires 'Carp' => '1.25';
requires 'Class::C3::Adopt::NEXT' => '0.07';
requires 'CGI::Simple::Cookie' => '1.109';
requires 'Data::Dump';
requires 'Data::OptList';
requires 'HTML::Entities';
requires 'HTML::HeadParser';
requires 'HTTP::Body'    => '1.22';
requires 'HTTP::Headers' => '1.64';
requires 'HTTP::Request' => '5.814';
requires 'HTTP::Response' => '5.813';
requires 'HTTP::Request::AsCGI' => '1.0';
requires 'Module::Pluggable' => '4.7';
requires 'Path::Class' => '0.09';
requires 'Scalar::Util';
requires 'Sub::Exporter';
requires 'Text::SimpleTable' => '0.03';
requires 'Time::HiRes';
requires 'Tree::Simple' => '1.15';
requires 'Tree::Simple::Visitor::FindByPath';
requires 'Try::Tiny' => '0.17';
requires 'Safe::Isa';
requires 'Task::Weaken';
requires 'Text::Balanced'; # core in 5.8.x but mentioned for completeness
requires 'MRO::Compat';
requires 'MooseX::Getopt' => '0.48';
requires 'String::RewritePrefix' => '0.004'; # Catalyst::Utils::resolve_namespace
requires 'Devel::InnerPackage'; # No longer core in blead
requires 'Plack' => '0.9991'; # IIS6+7 fix middleware
requires 'Plack::Middleware::ReverseProxy' => '0.04';
requires 'Plack::Test::ExternalServer';
requires 'Class::Data::Inheritable';
requires 'Encode' => '2.49';
requires 'LWP' => '5.837'; # LWP had unicode fail in 5.8.26
requires 'URI' => '1.65';
requires 'URI::ws' => '0.03';
requires 'JSON::MaybeXS' => '1.000000';
requires 'Stream::Buffered';
requires 'Hash::MultiValue';
requires 'Plack::Request::Upload';
requires 'CGI::Struct';
requires "Plack::Middleware::Conditional";
requires "Plack::Middleware::IIS6ScriptNameFix";
requires "Plack::Middleware::IIS7KeepAliveFix";
requires "Plack::Middleware::LighttpdScriptNameFix";
requires "Plack::Middleware::ContentLength";
requires "Plack::Middleware::Head";
requires "Plack::Middleware::HTTPExceptions";
requires "Plack::Middleware::FixMissingBodyInRedirect" => '0.09';
requires "Plack::Middleware::MethodOverride" => '0.12';
requires "Plack::Middleware::RemoveRedundantBody" => '0.03';

test_requires 'Test::Fatal';
test_requires 'Test::More' => '0.88';
test_requires 'Data::Dump';
test_requires 'HTTP::Request::Common';
test_requires 'IO::Scalar';
test_requires 'HTTP::Status';
test_requires 'JSON::MaybeXS';

# see also cpanfile for authordeps -- install via
# cpanm --installdeps --with-develop .

# aggregate tests if AGGREGATE_TESTS is set and a recent Test::Aggregate and a Test::Simple it works with is available
my @author_requires;
if ($ENV{AGGREGATE_TESTS} && can_use('Test::Simple', '0.88') && can_use('Test::Aggregate', '0.364')) {
    push(@author_requires, 'Test::Aggregate', '0.364');
    push(@author_requires, 'Test::Simple', '0.88');
    open my $fh, '>', '.aggregating';
}
else {
    unlink '.aggregating';
    tests 't/*.t t/aggregate/*.t';
}

push(@author_requires, 'CatalystX::LeakChecker', '0.05');
push(@author_requires, 'Catalyst::Devel', '1.0'); # For http server test
push(@author_requires, 'Test::WWW::Mechanize::Catalyst', '0.51');
push(@author_requires, 'Test::TCP', '2.00'); # ditto, ships Net::EmptyPort

author_tests('t/author');
author_requires(
  @author_requires,
  map {; $_ => 0 } qw(
  File::Copy::Recursive
  Starman
  MooseX::Daemonize
  Test::NoTabs
  Test::Pod
  Test::Pod::Coverage
  Test::Spelling
  Pod::Coverage::TrustPod
  Catalyst::Plugin::Params::Nested
  Catalyst::Plugin::ConfigLoader
));

if ($Module::Install::AUTHOR) {
    darwin_check_no_resource_forks();
}

resources(
    'MailingList' => 'http://lists.scsys.co.uk/cgi-bin/mailman/listinfo/catalyst',
    'IRC'         => 'irc://irc.perl.org/#catalyst',
    'license',    => 'http://dev.perl.org/licenses/',
    'homepage',   => 'http://dev.catalyst.perl.org/',
    # r/w: catagits@git.shadowcat.co.uk:Catalyst-Runtime.git
    # web: http://git.shadowcat.co.uk/gitweb/gitweb.cgi?p=catagits/Catalyst-Runtime.git;a=summary
    'repository', => 'git://git.shadowcat.co.uk/catagits/Catalyst-Runtime.git',
);

install_script glob('script/*.pl');
auto_install;
WriteAll;

print <<"EOF";

 Important:

    This library is for running Catalyst applications.

    For development and use of catalyst.pl and myapp_create.pl, make sure
    you also install the development tools package Catalyst::Devel.

        perl -MCPANPLUS -e 'install Catalyst::Devel' # or
        perl -MCPAN -e 'install Catalyst::Devel'     # or
        cpanm Catalyst::Devel

    To get some commonly used plugins, as well as the TT view and DBIC
    model, install Task::Catalyst in the same way.

 Have fun!
EOF

# NOTE - This is the version number of the _incompatible_ code,
#        not the version number of the fixed version.
my %conflicts = (
    'Catalyst::Plugin::SubRequest' => '0.14',
    'Catalyst::Model::Akismet' => '0.02',
    'Catalyst::Component::ACCEPT_CONTEXT' => '0.06',
    'Catalyst::Plugin::ENV' => '9999', # This plugin is just stupid, full stop
                                       # should have been a core fix.
    'Catalyst::Plugin::Unicode::Encoding' => '0.2',
    'Catalyst::Plugin::Authentication' => '0.10010', # _config accessor in ::Credential::Password
    'Catalyst::Authentication::Credential::HTTP' => '1.009',
    'Catalyst::Plugin::Session::Store::File'     => '0.16',
    'Catalyst::Plugin::Session'                  => '0.21',
    'Catalyst::Plugin::Session::State::Cookie'   => '0.10',
    'Catalyst::Plugin::Session::Store::FastMmap' => '0.09',
    'Catalyst::Controller::AllowDisable'         => '0.03',
    'Reaction'                                   => '0.001999',
    'Catalyst::Plugin::Upload::Image::Magick'    => '0.03',
    'Catalyst::Plugin::ConfigLoader'             => '0.22', # Older versions work but
                                                  # throw Data::Visitor warns
    'Catalyst::Devel'                            => '1.19',
    'Catalyst::Plugin::SmartURI'                 => '0.032',
    'CatalystX::CRUD'                            => '0.37',
    'Catalyst::Action::RenderView'               => '0.07',
    'Catalyst::Plugin::DebugCookie'              => '0.999002',
    'Catalyst::Plugin::Authentication'           => '0.100091',
    'CatalystX::Imports'                         => '0.03',
    'Catalyst::Plugin::HashedCookies'            => '1.03',
    'Catalyst::Action::REST'                     => '0.67',
    'CatalystX::CRUD'                            => '0.42',
    'CatalystX::CRUD::Model::RDBO'               => '0.20',
    'Catalyst::View::Mason'                      => '0.17',
#    Note these are not actually needed - they fail tests against the
#    new version, but still work fine..
#    'Catalyst::ActionRole::ACL'                  => '0.05',
#    'Catalyst::Plugin::Session::Store::DBIC'     => '0.11',
      'Test::WWW::Mechanize::Catalyst'            => '0.53', # Dep warnings unless upgraded.
);
check_conflicts(%conflicts);

# End of script, helper functions below.

sub darwin_check_no_resource_forks {
    if ($^O eq 'darwin') {
        my $osx_ver = `/usr/bin/sw_vers -productVersion`;
        chomp $osx_ver;

        # TAR on 10.4 wants COPY_EXTENDED_ATTRIBUTES_DISABLE
        # On 10.5 (Leopard) it wants COPYFILE_DISABLE
        my $attr = $osx_ver =~ /^10.(5|6|7|8)/  ? 'COPYFILE_DISABLE' : 'COPY_EXTENDED_ATTRIBUTES_DISABLE';

        makemaker_args(dist => { PREOP => qq{\@if [ "\$\$$attr" != "true" ]; then}.
                                          qq{ echo "You must set the ENV variable $attr to 'true',"; }.
                                          ' echo "to avoid getting resource forks in your dist."; exit 255; fi' });
    }
}
