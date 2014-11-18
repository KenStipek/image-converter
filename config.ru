require './script'
require 'unicorn/worker_killer'
use Unicorn::WorkerKiller::Oom, (192*(1024**2)), (256*(1024**2))
run Sinatra::Application