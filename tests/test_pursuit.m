function tests = test_pursuit
tests = functiontests(localfunctions);
end

function setupOnce(~)
addpath(fullfile(fileparts(mfilename('fullpath')), '..', '02-fox-rabbit-pursuit'));
end

function testCrossingSegments(tc)
verifyTrue(tc, segments_intersect([0 0], [2 2], [0 2], [2 0]));
end

function testParallelSegmentsDoNotIntersect(tc)
verifyFalse(tc, segments_intersect([0 0], [2 0], [0 1], [2 1]));
end

function testSegmentsThatWouldMeetIfExtended(tc)
% The lines cross at (3, 3), but the segments stop before it
verifyFalse(tc, segments_intersect([0 0], [1 1], [0 6], [1 5]));
end

function testFenceBlocksLineOfSight(tc)
A = [380; 600];
E = [450; 320];
verifyTrue(tc, segments_intersect([300; 400], [700; 450], A, E));
verifyFalse(tc, segments_intersect([0; 300], [0; 800], A, E));
end

function testConstantSpeedRabbitEscapes(tc)
res = simulate_chase();
verifyEqual(tc, res.outcome, 'Escaped');
% the rabbit reaches the burrow at exactly (R*pi/3) / 13 seconds
verifyEqual(tc, res.T, 800 * (pi/3) / 13, 'AbsTol', 1e-6);
verifyGreaterThan(tc, res.separation, 1);
end

function testFatigueChangesOutcome(tc)
res = simulate_chase(0.0002, 0.0008);
verifyEqual(tc, res.outcome, 'Captured');
verifyEqual(tc, res.separation, 0.1, 'AbsTol', 1e-6);
end
