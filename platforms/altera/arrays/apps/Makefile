SUBDIRS=arr_sum arr_inc

clean:
	for i in $(SUBDIRS); do (cd $$i; make -f ../../../_etc/Makefile.templ clean); done

clobber:
	for i in $(SUBDIRS); do (cd $$i; make -f ../../../_etc/Makefile.templ clobber); done
