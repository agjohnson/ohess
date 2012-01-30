use Test::More tests => 6;

BEGIN {
    use_ok('Ohess::Buildbot');
    use_ok('JSON');
}

# Test output from build bot
my $output = '{"blame":[],"builderName":"csistck","currentStep":null,"eta":null,"logs":[["stdio","http://build.ohess.orgbuilders/csistck/builds/2/steps/hg/logs/stdio"],["stdio","http://build.ohess.orgbuilders/csistck/builds/2/steps/shell/logs/stdio"],["stdio","http://build.ohess.orgbuilders/csistck/builds/2/steps/test/logs/stdio"]],"number":2,"properties":[["branch",null,"Build"],["buildername","csistck","Builder"],["buildnumber",2,"Build"],["got_revision","d4042827af4e91e47f080a09230710233149fca9","Source"],["project","","Build"],["repository","","Build"],["revision",null,"Build"],["slavename","perl514","BuildSlave"],["warnings-count",0,"WarningCountingShellCommand"],["workdir","/var/builds/perl514/csistck","slave"]],"reason":"The web-page \'force build\' button was pressed by \'aj\': Testing\n","results":0,"slave":"perl514","sourceStamp":{"branch":null,"changes":[],"hasPatch":false,"project":"","repository":"","revision":null},"steps":[{"eta":null,"expectations":[["output",4781,null]],"isFinished":true,"isStarted":true,"logs":[["stdio","http://build.ohess.orgbuilders/csistck/builds/2/steps/hg/logs/stdio"]],"name":"hg","results":[0,[]],"statistics":{},"step_number":0,"text":["update"],"times":[1327180228.7167079,1327180231.44521],"urls":{}},{"eta":null,"expectations":[["output",904,null]],"isFinished":true,"isStarted":true,"logs":[["stdio","http://build.ohess.orgbuilders/csistck/builds/2/steps/shell/logs/stdio"]],"name":"shell","results":[0,[]],"statistics":{},"step_number":1,"text":["\'/usr/bin/env","perl","...\'"],"times":[1327180231.4462221,1327180232.0300081],"urls":{}},{"eta":null,"expectations":[["output",1824,null]],"isFinished":true,"isStarted":true,"logs":[["stdio","http://build.ohess.orgbuilders/csistck/builds/2/steps/test/logs/stdio"]],"name":"test","results":[0,[]],"statistics":{"tests-failed":0,"tests-passed":22,"tests-total":22,"tests-warnings":0,"warnings":0},"step_number":2,"text":["test","22 tests","22 passed"],"times":[1327180232.0304799,1327180235.070601],"urls":{}}],"text":["build","successful"],"times":[1327180228.7165811,1327180235.0713451]}';

my $stats = Ohess::Buildbot::parse_stats(decode_json($output));

isnt($stats, undef, 'Parsing was not not okay');
is(ref $stats, "HASH", 'Parsing was okay');
is($stats->{passed}, 22, 'Correct passed return');
is($stats->{failed}, 0, 'Correct failed return');

