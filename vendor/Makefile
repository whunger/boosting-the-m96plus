all: install-wf

# V220_C008_97_WJDF21_OC4_BTC.fw
# V220_C009_97_WJ0902_ED097OC4_BTC.fw
# V220_C010_97_WJ1002_ED097OC4_BTC.fw
# V220_C018_97_WN1201_ED097OC4_BTC.fw
# V220_C021_97_WJ7301_OC4_BTC.fw
# V220_C023_97_WNA501_ED097OC4_BTC.fw
# V220_C064_97_WJAA01_OC4_BTC.fw
# V220_C064_97_WN4D01_ED097OC4_BTC.fw
# V220_C068_97_WJFF01_OC4_BTC.fw
# V220_C068_97_WN8C01_ED097OC4_BTC.fw
# V220_C073_97_WJ9601_OC4_BTC.fw
# V220_C073_97_WN9731_ED097OC4_BTC.fw
# V220_C073_97_WNA301_ED097OC4_BTC.fw: sharp, but noisy, some ghosting
# V220_C209_97_WJ5531_OC4_BTC.fw: much darker, ghosting
# V220_C212_97_WN2642_ED097OD2_CTC.fw: some ghosting
# V220_C228_97_WN3B41_ED097OD2_CTC.fw: very good, similar to WN3B42, but no full screen redraws all the time. But many crashes of apps and os instead?
# V220_C228_97_WN3B41_ED097TC1_CTC.fw: quite good overall, hangs sometimes?
# V220_C228_97_WN3B42_ED097OD2_CTC.fw: almost no ghosting, not as sharp as WN6441? Full screen redraw on transition standby -> on?
# V220_C243_97_WN6441_ED097OD2_CTC.fw: ghosting, good contrast, fast

EPDC := V220_C228_97_WN3B41_ED097TC1_CTC

install-wf: wf.zip
	adb shell "cat /dev/null > /vendor/firmware/imx/epdc.fw"
	unzip -j -o wf.zip wf/97/$(EPDC).fw
	adb push $(EPDC).fw /vendor/firmware/imx/epdc.fw

wf.zip:
	unzip -j ../M96_KK_2017-05-02_19-37_dev_fbc2cc2_user.zip "M96_2017-05-02_19-37_dev_fbc2cc2_user/Profiles/MX6SL Linux Update/OS Firmware/files/waveform/wf.zip"

epdc.fw:
	unzip -j ../M96_KK_2017-05-02_19-37_dev_fbc2cc2_user.zip "M96_2017-05-02_19-37_dev_fbc2cc2_user/Profiles/MX6SL Linux Update/OS Firmware/files/waveform/epdc.wf"

clean:
	rm -rf wf.zip *.fw