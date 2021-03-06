set +x

echo "" >> .messages.txt
echo "  Thank you for installing LIBEFP." >> .messages.txt
echo "    Manual:  http://www.libefp.org/" >> .messages.txt
echo "    GitHub:  github.com/ilyak/libefp" >> .messages.txt
echo "    Binary:  anaconda.org/psi4/libefp" >> .messages.txt
echo "    Inputs:  ${PREFIX}/share/psi4/samples/libefp" >> .messages.txt
echo "    Test (after first activating conda installation or environment):" >> .messages.txt
echo "      psi4 \"\$(dirname \$(which psi4))\"/../share/psi4/samples/libefp/qchem-qmefp-sp/test.in" >> .messages.txt
echo "" >> .messages.txt

