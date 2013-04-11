function [event_time, interarrival_time] = simulatenonhomopoisson(time_width, rate, time)
%% simulatenonhomopoisson
% simulates event- and inter-arrival times of the non-homogeneous Poisson process within the given time-width and rate
%
%% References
% thinning algorithm is used, which are described in 
% Simulation, New York, Academic Press.
% Sheldon M. Ross, Chapter 5.
%

%% setup
if nargin < 3
  time = linspace(0, time_width, numel(rate) + 1);
  time(1) = [];
end
cs = spline(time, rate);

time_fine = linspace(0, time_width, 10000);
rate_max  = max(ppval(cs, time_fine));
plot(time_fine, ppval(cs, time_fine));

%% simulation
event_time = 0;
t = 0;

while true
  t = t - (1./rate_max) * log(rand);
  if t > time_width
    break
  end
  rate_t = ppval(cs, t);
  if rand(1) < (rate_t/rate_max)
    event_time = [event_time; t];
  end
end

interarrival_time = diff(event_time);

% delete t=0 from event_time
event_time(1) = [];

