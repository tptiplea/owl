import os
import matplotlib.pyplot as plt
import time
from subprocess import Popen, PIPE
import numpy as np


def fail_if_error(error):
    if error:
        print(error)
        raise AssertionError()


def extract_runtime(output):
    ind = output.find(b'Execution time: ')
    stop_ind = output.find(b' seconds', ind)
    return float(output[ind + 16:stop_ind])


def run_benchmark(command, dim):
    dim = [str(x) for x in dim]
    print('Running command: "', command, '" with dims', dim)
    results = []
    for _ in range(5):  # TODO: change here the number of repetitions
        p = Popen(command + dim, stdin=None, stdout=PIPE, stderr=PIPE)
        output, error = p.communicate()
        fail_if_error(error)
        results.append(extract_runtime(output))

    print('Got the following runtimes:', results)
    return int(1000 * np.mean(np.array(results)))


def run_benchmark_all_dims(command, dims):
    return [run_benchmark(command, dim) for dim in dims]


os.chdir('/Users/tudort/project/owl')
# Build the binaries.
p = Popen(['make'], stdin=None, stdout=PIPE, stderr=PIPE)
output, error = p.communicate()
fail_if_error(error)


os.chdir('/Users/tudort/project/owl/_build/default/bin/benchmarks')

# The benchmarks.
benchmarks = {
    'indexing_eval': [],
    'slicing_eval': [],
    'slicing_left_eval': [],
    'map_eval': [],
    'fold_eval': [],
    'fold_low_eval': [],
    'fold_high_eval': [],
    'scan_eval': [],
    'scan_low_eval': [],
    'scan_high_eval': []
}

# Commands for running the benchmarks.
for b in benchmarks.keys():
    benchmarks[b].append((['native/' + b + '.exe'], 0))
    benchmarks[b].append((['pure/' + b + '.exe'], 1))
    benchmarks[b].append((['pure/' + b + '.bc'], 2))
    benchmarks[b].append((['node', 'pure/' + b + '.bc.js'],  3))


# The shapes of the Ndarrays.
dims = [[100],
        [300],
        [600],
        [33, 33],
        [50, 50],
        [70, 70],
        [100, 100],
        [150, 150],
        [200, 200],
        [250, 250],
        [300, 300],
        [350, 350],
        [400, 400],
        [450, 450],
        [500, 500],
        [600, 600],
        [700, 700],
        [800, 800],
        [900, 900],
        [100, 100, 100],
        [120, 120, 120],
        [140, 140, 140],
        [160, 160, 160],
        [180, 180, 180],
        [200, 200, 200],
        [220, 220, 220],
        [240, 240, 240],
        [260, 260, 260],
        [280, 280, 280],
        [300, 300, 300]]  # TODO: change here the dimensions
x_labels = ['10^{:.1f}'.format(np.log10(np.prod(np.array(dim)))) for dim in dims]

# The colours and shapes for the data
colours = ['r-', 'm--', 'b--', 'g-']
legend = ['native-original', 'native-new', 'bytecode', 'node.js']

# The dir where we save the results.
results_dir = '/Users/tudort/project/owl/bin/benchmarks/results/' + time.strftime('%d-%m-%Y--%H:%M:%S') + '/'
os.makedirs(results_dir)

for fig_id, b in enumerate(benchmarks.keys()):
    print('Running the', b, 'benchmark!')

    plt.figure(fig_id + 1)
    plt.title(b)

    plot_handlers = [None for _ in range(len(colours))]
    for command, colour_id in benchmarks[b]:
        results = run_benchmark_all_dims(command, dims)
        plot_handlers[colour_id], = plt.plot(x_labels, results, colours[colour_id])

    plt.xlabel('Ndarray size')
    plt.ylabel('Time (ms)')

    plt.legend(plot_handlers, legend)

    plt.savefig(results_dir + b + '.eps', format='eps')
    plt.close()
