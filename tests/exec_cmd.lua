local l = exec.cmd'l'
l()
fmt.print('first l() ok\n')
fmt.print('next l() will fail\n')
l.error = 'custom error'
l.errexit = true
l()
