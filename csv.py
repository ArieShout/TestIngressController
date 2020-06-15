import sys
import json

D = {
}
with open(sys.argv[1], 'r') as f:
    lines = f.readlines()
    for line in lines:
        if line.find('pod-svc') != -1:
            line = line.strip()
            words = line.split()
            ws = words[0].split('.')
            val = words[1]
            client = ws[2]
            pod = ws[3]

            cd = D.get(client, {})
            cd[pod] = val
            D[client] = cd

# first line pinrt the client pod number
k = []
for x in D.keys():
    k.append(int(x))

k.sort()

for clients in k:
    cs = '%s' % clients

    print('%s,' % cs),

    cd = D.get(cs, {})

    t = []
    for tmp in cd.keys():
        t.append(int(tmp))
    t.sort()

    for appPods in t:
        ts = '%s' % appPods
        v = cd[ts]
        print('%s,' % v),
    print('')

